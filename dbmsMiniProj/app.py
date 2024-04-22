from flask import render_template, request, Flask
from flask import request, jsonify, session, abort
import pymysql
import secrets
from datetime import datetime, timedelta
import numpy as np


app = Flask(__name__)


db = pymysql.connect(host='127.0.0.1',user='root',passwd='')
cursor = db.cursor()
cursor.execute("USE miniprojdb;")

usernmInSes = ""
userIdInSes = 0

secret_key = secrets.token_hex(16)  # Generate a 32-character (16 bytes) hexadecimal string
app.secret_key = secret_key


@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', 'http://localhost')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type')
    response.headers.add('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
    return response


@app.route("/")
def mainpg():
    return render_template("index.html")


@app.route('/login', methods=['OPTIONS'])
def options():
    return '', 200


@app.route("/login", methods=['POST'])
def login():
    cursor = db.cursor()
    global userIdInSes
    global usernmInSes
    if request.method == 'POST':
        data = request.get_json()
        username = data.get('username')
        password = data.get('password')

        # Check if reg_id exists in users table
        with cursor as cur:
            sql_user = "SELECT userid FROM users WHERE regid = %s AND password = %s"
            cur.execute(sql_user, (username, password))
            user_id = cur.fetchone()

            if user_id:
                usernmInSes = username
                userIdInSes = user_id[0]
                return "valid"
            
            else:
                # Check if username exists in student, teacher, or non_teaching_staff table

                cur.execute("SELECT checkIfExists(%s);", (username,))
                yn = cur.fetchone()

                if yn==1 :
                    # Insert user into users table with password
                    sql_insert_user = "INSERT INTO users (regid,password) VALUES (%s, %s)"
                    cur.execute(sql_insert_user, (username, password))
                    db.commit()
                    # Retrieve the newly inserted user's userid
                    cur.execute("SELECT userid FROM users WHERE regid = %s", (username,))
                    user_id = cur.fetchone()
                    userIdInSes = user_id[0]
                    usernmInSes = username
                    return "valid"
                
                elif yn==0:
                    return "Wrong Password"

                else:
                    return "Invalid credentials."

    return "Method not allowed"

@app.route("/isLoggedIn",  methods=['GET', 'POST'])
def isLoggedIn():
    if userIdInSes != 0:
        return "logged in"
    
    else: 
        return ""

@app.route("/profile", methods=['GET', 'POST'])
def profile():
    print(usernmInSes)
    cursor = db.cursor()
    if userIdInSes != 0:
        user_id = userIdInSes

        # Fetch issued book data for the logged-in user
        with cursor as cur:
            sql = """
                SELECT issues.issueid, books.name, issues.issuedt, issues.returndt, issues.fine
                FROM issues
                INNER JOIN books ON issues.bookid = books.bookid
                WHERE issues.userid = %s
            """
            cur.execute(sql, (user_id,))
            
            
        if cur.rowcount<=0:
            # If no books are issued, return an empty list
            return jsonify({'response': [[]],'user':usernmInSes})
        else:
            # If books are issued, return the list of issued books as JSON
            lst = []
            for row in cur:
                inlst = []
                for val in row:
                    inlst.append(val)
                lst.append(inlst)
            
            print(lst)
            return jsonify({'response': lst, 'user':usernmInSes})
            
    else:
        # If the user is not logged in, return a 401 Unauthorized status code
        return jsonify({'response': [[]], 'user':usernmInSes})
    



@app.route("/checkAdmin", methods=['POST'])
def checkAdmin():
    print(usernmInSes)
    if usernmInSes != 'admin' :
        return "not"  # Return error if the user is not an admin
    return "yes"

@app.route("/add_book", methods=['POST'])
def add_book():
    cursor = db.cursor()
    data = request.get_json()
    title = data.get('title')
    author = data.get('author')
    publication_name = data.get('publication')
    publication_contact = data.get('publication_contact')
    edition = data.get('Edition')
    count_str = data.get('Count')
    book_type = data.get('type')

    # Validate count input
    try:
        count = int(count_str)
    except ValueError:
        return "Invalid count value. Count must be an integer."

    with cursor as cur:
        # Check if publication already exists in the publisher table
        sql_check_pub = "SELECT pid FROM publisher WHERE name = %s"
        cur.execute(sql_check_pub, (publication_name,))
        publisher_row = cur.fetchone()

        if publisher_row:
            pid = publisher_row[0]
        else:
            # If publication does not exist, insert it into the publisher table
            sql_insert_pub = "INSERT INTO publisher (name, contact) VALUES (%s, %s)"
            cur.execute(sql_insert_pub, (publication_name, publication_contact))
            pid = cur.lastrowid  # Get the last inserted id (pid)

        # Insert the book into the books table
        sql_insert_book = "INSERT INTO books (name, pid, avail_status, edition, count) VALUES (%s, %s, %s, %s, %s)"
        if count > 0:
            cur.execute(sql_insert_book, (title, pid, "a", edition, count))
        else:
            cur.execute(sql_insert_book, (title, pid, "na", edition, count))
        book_id = cur.lastrowid  # Get the last inserted id (book_id)

        # Insert book into the appropriate type table
        sql_insert_subtype = None
        if book_type == 'textbook':
            sql_insert_subtype = "INSERT INTO textbooks (bookid, author) VALUES (%s, %s)"
        elif book_type == 'journal':
            sql_insert_subtype = "INSERT INTO journals (bookid, author) VALUES (%s, %s)"
        elif book_type == 'magazine':
            sql_insert_subtype = "INSERT INTO magazines (bookid, author) VALUES (%s, %s)"
        elif book_type == 'novel':
            sql_insert_subtype = "INSERT INTO novel (bookid, author) VALUES (%s, %s)"
        
        if sql_insert_subtype:
            cur.execute(sql_insert_subtype, (book_id, author))
        
        db.commit()

    return "Book added successfully"


@app.route("/removebk", methods=['POST', 'GET'])
def removebk():
    cursor = db.cursor()
    data = request.get_json()
    remid = data.get('remid')
    try: 
        cursor.execute("SELECT BOOKID FROM books WHERE BOOKID = %s", (remid,))
        result = cursor.fetchone()
        if result is not None:
            cursor.execute("SELECT BOOKID FROM textbooks WHERE BOOKID = %s", (remid,))
            tb = cursor.fetchone()
            if tb is not None:
                cursor.execute("DELETE FROM textbooks WHERE BOOKID = %s", (remid,))
                cursor.execute("DELETE FROM books WHERE BOOKID = %s", (remid,))

            cursor.execute("SELECT BOOKID FROM journals WHERE BOOKID = %s", (remid,))
            j = cursor.fetchone()
            if j is not None:
                cursor.execute("DELETE FROM journals WHERE BOOKID = %s", (remid,))
                cursor.execute("DELETE FROM books WHERE BOOKID = %s", (remid,))

            cursor.execute("SELECT BOOKID FROM magazines WHERE BOOKID = %s", (remid,))
            m = cursor.fetchone()
            if m is not None:
                cursor.execute("DELETE FROM magazines WHERE BOOKID = %s", (remid,))
                cursor.execute("DELETE FROM books WHERE BOOKID = %s", (remid,))

            cursor.execute("SELECT BOOKID FROM novel WHERE BOOKID = %s", (remid,))
            n = cursor.fetchone()
            if n is not None:
                cursor.execute("DELETE FROM novel WHERE BOOKID = %s", (remid,))
                cursor.execute("DELETE FROM books WHERE BOOKID = %s", (remid,))

            db.commit()
            return "removed"
        
        else:
            return ""

    except Exception as e:
        print(f"An error occurred: {e} ", 500)
        return f"An error occurred: {e} ", 500


@app.route("/issuebk", methods=['POST'])
def issuebk():
    data = request.get_json()
    bookid = data.get('bookID')
    regid = data.get('userID')

    try:
        with cursor as cur:
            cur.execute("SELECT avail_status, count FROM books WHERE bookid = %s", (bookid,))
            book_data = cur.fetchone()
            if book_data is None:
                print("Book non-existent")
                return "error"

            avail_status = book_data[0]
            book_count = book_data[1]

            if avail_status == 'na':
                print("Books out of stock na")
                return "error"
            
            elif book_count <= 0:
                print("Books out of stock count=-1")
                return "error"
            
            else:
                if book_count <= 3:
                    cur.execute("SELECT type FROM users WHERE userID = %s", (regid,))
                    user_data = cur.fetchone()
                    if user_data is None:
                        print("No user")
                        return "error"

                    usertype = user_data[0]
                    if usertype == 'nonTeaching':
                        print("Non-teaching staff cannot issue")
                        return "Non-teaching staff cannot issue"
                    else:
                        issue_date = datetime.now().date()
                        cur.execute("INSERT INTO issues(userid, bookid, issuedt, returndt, fine) VALUES (%s, %s, %s)",
                                    (regid, bookid, issue_date))

                        if book_count - 1 == 0:
                            cur.execute("UPDATE books SET avail_status = 'na', count = count - 1 WHERE bookid = %s", (bookid,))
                        else:
                            cur.execute("UPDATE books SET count = count - 1 WHERE bookid = %s", (bookid,))
                        db.commit()
                        return "Book issued successfully."
                else:
                    issue_date = datetime.now().date()
                    cur.execute("INSERT INTO issues(userid, bookid, issuedt, returndt, fine) VALUES (%s, %s, %s)",
                                (regid, bookid, issue_date))

                    if book_count - 1 == 0:
                        cur.execute("UPDATE books SET avail_status = 'na', count = count - 1 WHERE bookid = %s", (bookid,))
                    else:
                        cur.execute("UPDATE books SET count = count - 1 WHERE bookid = %s", (bookid,))
                    db.commit()
                    return "Book issued successfully."

    except pymysql.Error as e:
        print(f"An error occurred: {e}")
        return f"An error occurred: {e}"


@app.route("/execute_search", methods=['POST', 'GET'])
def execute_search():
    cursor = db.cursor()
    data = request.get_json()
    search_type = data.get('search_type')
    query = data.get('query')

    try:
        with cursor as cur:
            if search_type == "title":
                # Search by title
                sql = """
                    SELECT b.name, b.edition, b.avail_status, p.name AS publication_name
                    FROM books AS b
                    INNER JOIN publisher AS p ON b.pid = p.pid
                    WHERE b.name LIKE %s
                """
                cur.execute(sql, ('%' + query + '%',))
            elif search_type == "author":
                # Search by author
                sql = """
                    SELECT b.*
                    FROM books AS b
                    INNER JOIN (
                        SELECT bookid FROM journals WHERE author LIKE %s
                        UNION
                        SELECT bookid FROM magazines WHERE author LIKE %s
                        UNION
                        SELECT bookid FROM textbooks WHERE author LIKE %s
                        UNION
                        SELECT bookid FROM novel WHERE author LIKE %s
                    ) AS sub
                    ON b.bookid = sub.bookid
                """
                cur.execute(sql, ('%' + query + '%', '%' + query + '%', '%' + query + '%', '%' + query + '%'))
            elif search_type == "publication_name":
                # Search by publication name
                sql = """
                    SELECT b.name, b.edition, b.avail_status, p.name AS publication_name
                    FROM books AS b
                    INNER JOIN publisher p ON b.pid = p.pid
                    WHERE p.name LIKE %s
                """
                cur.execute(sql, ('%' + query + '%',))

            else:
                return jsonify({"error": "Invalid search type."}), 400

            lst = []
            for row in cur:
                inlst = []
                for val in row:
                    inlst.append(val)
                lst.append(inlst)

            cols = [column[0] for column in cursor.description]

            headlen = len(cols)

            if cur.rowcount>0:
                print(lst)
                return jsonify({'response': lst, 'colnames':cols, 'colcount':headlen})
            
            else:
                return jsonify({'response': [[]], 'colnames':cols, 'colcount':headlen})              

    except pymysql.Error as e:
        return jsonify({"error": f"An error occurred: {e}"}), 500


@app.route("/dispall", methods=['POST'])  
def dispall():
    cursor = db.cursor()
    query = "SELECT NAME FROM books;"
    cursor.execute(query)
    lst = []
    for val in cursor:
        lst.append(val[0])
    return jsonify({'response': lst})


@app.route("/logout",  methods=['POST', 'GET'])
def logout():
    global userIdInSes
    userIdInSes = 0
    global usernmInSes
    usernmInSes = ""
    return "valid"
    


if __name__ =='__main__':
    app.run()


