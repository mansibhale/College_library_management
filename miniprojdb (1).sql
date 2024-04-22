-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 17, 2024 at 10:17 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `miniprojdb`
--

DELIMITER $$
--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `checkIfExists` (`usn` VARCHAR(30)) RETURNS INT(11) DETERMINISTIC BEGIN
        DECLARE ret INT DEFAULT 2;

        IF EXISTS (SELECT RegID FROM users WHERE RegID = usn) THEN
            SET ret = 0;
        ELSEIF EXISTS (SELECT STUDID FROM students WHERE STUDID = usn) THEN
            SET ret = 1;
        ELSEIF EXISTS (SELECT ID FROM staff WHERE ID = usn) THEN
            SET ret = 1;
        END IF;

        RETURN ret;
    END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `BOOKID` int(11) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `PID` int(11) DEFAULT NULL,
  `AVAIL_STATUS` enum('a','na') DEFAULT NULL,
  `EDITION` int(11) DEFAULT NULL,
  `COUNT` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`BOOKID`, `NAME`, `PID`, `AVAIL_STATUS`, `EDITION`, `COUNT`) VALUES
(1, 'Database System Concepts', 1, 'a', 7, 10),
(2, 'Operating System Concepts', 1, 'a', 10, 15),
(3, 'Digital Design: Principles and Practices', 2, 'a', 5, 12),
(4, 'Electric Circuits', 2, 'a', 11, 13),
(5, 'Calculus: Early Transcendentals', 3, 'a', 8, 20),
(6, 'Introduction to Chemical Engineering Thermodynamics', 3, 'a', 7, 18),
(7, 'Pattern Recognition and Machine Learning', 4, 'a', 1, 9),
(8, 'Introduction to Robotics: Mechanics and Control', 4, 'a', 4, 8),
(9, 'Programming Language Pragmatics', 5, 'a', 4, 11),
(10, 'Biomedical Engineering: Bridging Medicine and Technology', 5, 'a', 2, 7),
(11, 'Mechanical Engineering Design', 6, 'a', 10, 22),
(12, 'Structural Analysis', 6, 'a', 10, 19),
(13, 'Fundamentals of Physics', 7, 'a', 10, 25),
(14, 'Introduction to Flight', 7, 'a', 8, 17),
(15, 'Computer Organization and Design', 8, 'a', 5, 14),
(16, 'Operating Systems: Internals and Design Principles', 8, 'a', 10, 16),
(17, 'Introduction to Environmental Engineering', 9, 'na', 5, 1),
(18, 'Applied Petroleum Reservoir Engineering', 9, 'na', 3, 2),
(19, 'Introduction to Robotics: Mechanics and Control', 10, 'na', 4, 3),
(20, 'Introduction to Algorithms', 10, 'na', 3, 4),
(21, 'To Kill a Mockingbird', 11, 'a', 1, 20),
(22, '1984', 12, 'a', 1, 25),
(23, 'The Great Gatsby', 13, 'a', 1, 18),
(24, 'Pride and Prejudice', 14, 'a', 1, 22),
(25, 'The Catcher in the Rye', 15, 'a', 1, 15),
(26, 'Lord of the Flies', 16, 'na', 1, 19),
(27, 'Brave New World', 11, 'a', 1, 21),
(28, 'Wuthering Heights', 12, 'a', 1, 17),
(29, 'Jane Eyre', 17, 'na', 1, 23),
(30, 'The Grapes of Wrath', 12, 'a', 1, 20),
(31, 'Shriman Yogi', 18, 'a', 1, 30),
(32, 'Asa Mi Asami', 19, 'a', 1, 28),
(33, 'Satyache Prayog', 20, 'na', 1, 25),
(34, 'Purushottam', 21, 'a', 1, 22),
(35, 'Shyamchi Aai', 22, 'a', 1, 19),
(36, 'Journal of Biomechanics', 7, 'a', 1, 5),
(37, 'Applied Physics Letters', 7, 'a', 1, 3),
(38, 'International Journal of Heat and Mass Transfer', 4, 'a', 1, 4),
(39, 'Journal of Machine Learning Research (JMLR)', 4, 'a', 1, 2),
(40, 'IEEE Transactions on Robotics', 23, 'a', 1, 9),
(41, 'IEEE Transactions on Pattern Analysis and Machine Intelligence', 23, 'na', 1, 10),
(42, 'Wired', 24, 'a', 1, 5),
(43, 'Ars Technica', 24, 'a', 1, 8),
(44, 'Gadget', 24, 'a', 1, 20),
(45, 'Backchannel', 24, 'a', 1, 30),
(46, 'Epicenter', 24, 'a', 1, 9),
(129, 'The immortals of Meluha', 12, 'a', 1, 3),
(130, 'Dollar bahu', 26, 'a', 1, 3);

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

CREATE TABLE `department` (
  `depid` int(11) NOT NULL,
  `name` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `department`
--

INSERT INTO `department` (`depid`, `name`) VALUES
(1, 'Computer Engineering'),
(2, 'Information Technology'),
(3, 'Electronics and Telecommunicat'),
(4, 'Mechanical Engineering'),
(5, 'Instrumentation Engineering'),
(6, 'Civil Engineering'),
(7, 'Basic Sciences'),
(8, 'Helper');

-- --------------------------------------------------------

--
-- Table structure for table `has_sub`
--

CREATE TABLE `has_sub` (
  `SUBID` int(11) NOT NULL,
  `BOOKID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `has_sub`
--

INSERT INTO `has_sub` (`SUBID`, `BOOKID`) VALUES
(1, 5),
(2, 3),
(3, 6),
(4, 9),
(5, 9),
(6, 17),
(7, 0),
(8, 0),
(9, 13),
(10, 5),
(11, 20),
(12, 0),
(13, 9),
(14, 0),
(15, 3),
(16, 1),
(17, 2),
(18, 0),
(19, 7),
(20, 5),
(15, 3),
(15, 4),
(2, 4),
(15, 15),
(17, 16);

-- --------------------------------------------------------

--
-- Table structure for table `isin`
--

CREATE TABLE `isin` (
  `ID` varchar(10) NOT NULL,
  `depid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `isin`
--

INSERT INTO `isin` (`ID`, `depid`) VALUES
('t101', 1),
('t102', 3),
('t103', 4),
('t104', 5),
('t105', 6),
('t106', 7),
('t107', 3),
('t108', 1),
('t109', 2),
('t110', 2),
('n101', 8),
('n102', 8),
('n103', 8),
('n104', 8),
('n105', 8),
('n106', 8),
('n107', 8),
('n108', 8),
('n109', 8),
('n110', 8);

-- --------------------------------------------------------

--
-- Table structure for table `issues`
--

CREATE TABLE `issues` (
  `issueID` int(11) NOT NULL,
  `USERID` int(11) DEFAULT NULL,
  `BOOKID` int(11) DEFAULT NULL,
  `issueDt` date NOT NULL,
  `returnDt` date DEFAULT NULL,
  `Fine` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `issues`
--

INSERT INTO `issues` (`issueID`, `USERID`, `BOOKID`, `issueDt`, `returnDt`, `Fine`) VALUES
(1, 19, 6, '2024-02-14', '2024-03-17', 64),
(2, 6, 16, '2024-02-22', '2024-03-27', 68),
(3, 4, 10, '2024-03-10', '2024-03-29', 38),
(4, 9, 31, '2024-01-02', '2024-01-18', 0),
(5, 11, 20, '2024-01-20', '2024-02-29', NULL),
(6, 7, 36, '2024-01-02', NULL, NULL),
(7, 20, 15, '2024-02-20', NULL, NULL),
(8, 9, 30, '2024-02-23', NULL, NULL),
(9, 15, 11, '2024-04-04', '2024-01-24', NULL),
(10, 17, 23, '2024-01-23', '2024-02-04', NULL),
(11, 2, 34, '2024-02-01', '2024-01-18', NULL),
(12, 21, 30, '2024-02-28', NULL, NULL),
(13, 22, 7, '2024-01-25', NULL, NULL),
(14, 1, 2, '2024-03-01', '2024-03-27', NULL),
(15, 18, 4, '2024-03-03', '2024-01-15', NULL),
(16, 3, 39, '2024-01-23', NULL, NULL),
(17, 12, 33, '2024-02-01', '2024-03-25', NULL),
(18, 4, 12, '2024-02-05', '2024-03-19', NULL),
(19, 9, 27, '2024-02-14', '2024-03-23', 16),
(20, 8, 24, '2024-01-30', NULL, NULL),
(22, 1, 46, '2024-04-14', '2024-04-29', 0);

--
-- Triggers `issues`
--
DELIMITER $$
CREATE TRIGGER `addis` BEFORE INSERT ON `issues` FOR EACH ROW BEGIN
    DECLARE dt DATE;
    SELECT CURRENT_DATE() INTO dt;
    SET NEW.issueDt = dt;
    END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `finetrig` BEFORE UPDATE ON `issues` FOR EACH ROW BEGIN
	DECLARE r DATE;
    DECLARE i DATE;
    SELECT issues.issueDt INTO i FROM issues WHERE issueID=NEW.issueID;
    SELECT issues.returnDt INTO r FROM issues WHERE issueID=NEW.issueID;
    IF r IS NULL
    THEN SET r=NEW.returnDt;
    END IF;
    SET NEW.Fine = 2*(DATEDIFF(r, i)-30);
    IF NEW.Fine<0 THEN SET NEW.Fine = 0;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `limitTrigger` BEFORE INSERT ON `issues` FOR EACH ROW BEGIN 
    	DECLARE errormsg VARCHAR(150) DEFAULT "Book Issued successfully.";
        DECLARE cnt INT;
		IF('Student' IN (SELECT Type FROM users WHERE users.UserID=NEW.USERID) OR 'Teaching' IN (SELECT Type FROM users WHERE users.UserID=NEW.USERID))
    	THEN 
    		IF('na' IN (SELECT AVAIL_STATUS FROM books WHERE books.BOOKID=NEW.BOOKID))
            THEN SET errormsg = "Insufficient count of required book";
            END IF;
        ELSE
        	SELECT books.COUNT INTO cnt FROM books WHERE books.BOOKID=NEW.BOOKID;
        	IF(cnt<3)
            THEN SET errormsg = "Insufficient count of required book";
            END IF;
        END IF;
        
        IF errormsg = 'INVALID USER' 
        THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormsg;
    	END IF;
        
	END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `journals`
--

CREATE TABLE `journals` (
  `BOOKID` int(11) DEFAULT NULL,
  `AUTHOR` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `journals`
--

INSERT INTO `journals` (`BOOKID`, `AUTHOR`) VALUES
(36, 'Andrew Lee'),
(37, 'Robert Johnson'),
(38, 'Ryan Martinez'),
(39, 'John Smith'),
(40, 'Kevin Brown'),
(41, 'Emily Wang');

-- --------------------------------------------------------

--
-- Table structure for table `magazines`
--

CREATE TABLE `magazines` (
  `BOOKID` int(11) DEFAULT NULL,
  `AUTHOR` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `magazines`
--

INSERT INTO `magazines` (`BOOKID`, `AUTHOR`) VALUES
(42, 'Steven Levy'),
(43, 'Timothy B. Lee'),
(44, 'David Pierce'),
(45, 'Steven Levy'),
(46, 'Evgeny Morozov');

-- --------------------------------------------------------

--
-- Table structure for table `non_teaching_staff`
--

CREATE TABLE `non_teaching_staff` (
  `ID` varchar(10) DEFAULT NULL,
  `section` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `non_teaching_staff`
--

INSERT INTO `non_teaching_staff` (`ID`, `section`) VALUES
('n101', 'Accounts'),
('n102', 'Housekeeping'),
('n103', 'Administration'),
('n104', 'Housekeeping'),
('n105', 'Accounts'),
('n106', 'Administration'),
('n107', 'Housekeeping'),
('n108', 'Administration'),
('n109', 'Housekeeping'),
('n110', 'Accounts');

-- --------------------------------------------------------

--
-- Table structure for table `novel`
--

CREATE TABLE `novel` (
  `BOOKID` int(11) DEFAULT NULL,
  `AUTHOR` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `novel`
--

INSERT INTO `novel` (`BOOKID`, `AUTHOR`) VALUES
(21, 'Harper Lee'),
(22, 'George Orwell'),
(23, 'F. Scott Fitzgerald'),
(24, 'Jane Austen'),
(25, 'J.D. Salinger'),
(26, 'William Golding'),
(27, 'Aldous Huxley'),
(28, 'Emily Bronte'),
(29, 'Charlotte Bronte'),
(30, 'John Steinbeck'),
(31, 'Ranjit Desai'),
(32, 'P. L. Deshpande'),
(33, 'Mahatma Gandhi'),
(34, 'Ranjit Desai'),
(35, 'Sane Guruji'),
(129, 'Amish'),
(130, 'Sudha Murthy');

-- --------------------------------------------------------

--
-- Table structure for table `publisher`
--

CREATE TABLE `publisher` (
  `PID` int(11) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `CONTACT` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `publisher`
--

INSERT INTO `publisher` (`PID`, `NAME`, `CONTACT`) VALUES
(1, 'Pearson Education', 'ieee.tro.eic@gmail.com'),
(2, 'McGraw-Hill Education', 'support.india@mheducation.com'),
(3, 'Wiley', 'indianewsroom@wiley'),
(4, 'Springer', 'Chakraborty@springernature.com'),
(5, 'O\'Reilly Media', 'information@oreilly.co.uk'),
(6, 'Cambridge University Press', 'cupmum@cambridge.org'),
(7, 'Elsevier', 'Indiacontact@elsevier.com'),
(8, 'Addison-Wesley', 'group@addison.org'),
(9, 'CRC Press', 'contact@crc.com'),
(10, 'MIT Press', 'allenkc@mit.edu'),
(11, 'HarperCollins', 'harper_india@harpercollins-india.com'),
(12, 'Penguin Books', 'contact@penguin.com'),
(13, 'Random House', 'sgupta@penguinrandomhouse.in'),
(14, 'Hachette Book Group', 'sales@hachetteindia.com'),
(15, 'Simon & Schuster', 'cservice@simonandschuster.co.in'),
(16, 'Macmillan Publishers', 'mdlqueries@macmillan.co.uk'),
(17, 'Vintage Classics', 'VintagePublicity@penguinrandomhouse.co.uk'),
(18, 'My Publications', 'sales@mypublications.in'),
(19, 'Rajhans Publications', 'rajhans@gmail.com'),
(20, 'Samarth Publications', 'contact@samarthpublication.in'),
(21, 'Gyaneshwar Publications', 'gyaneshwar@gmail.com'),
(22, 'Vishwas Publications', 'sales@vishwas.in'),
(23, 'IEEE Transactions on Robotics', 'products@ieee.org'),
(24, 'Condé Nast', 'contact@conde.com'),
(25, 'Condé Nast', 'contact@conde.com'),
(26, 'Punguin Books', 'contact@penguin.com');

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `ID` varchar(10) NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `depid` int(11) NOT NULL,
  `EMAIL` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`ID`, `NAME`, `depid`, `EMAIL`) VALUES
('admin', 'Jack', 8, 'admin@college.com'),
('n101', 'Mohan Patel Admin', 8, 'mohan.patel@gmail.com'),
('n102', 'Divya Sharma', 8, 'divya.sharma@gmail.com'),
('n103', 'Kartik Reddy', 8, 'kartik.reddy@gmail.com'),
('n104', 'Shreya Das', 8, 'shreya.das@gmail.com'),
('n105', 'Rohan Joshi', 8, 'rohan.joshi@gmail.com'),
('n106', 'Kavita Singh', 8, 'kavita.singh@gmail.com'),
('n107', 'Siddharth Gupta', 8, 'siddharth.gupta@gmail.com'),
('n108', 'Meera Iyer', 8, 'meera.iyer@gmail.com'),
('n109', 'Sanjay Khanna', 8, 'sanjay.khanna@gmail.com'),
('n110', 'Namrata Joshi', 8, 'namrata.joshi@gmail.com'),
('t101', 'Rajesh Kumar', 1, 'rajesh.kumar@gmail.com'),
('t102', 'Priya Patil', 3, 'priya.patil@gmail.com'),
('t103', 'Ankit Sharma', 4, 'ankit.sharma@gmail.com'),
('t104', 'Deepika Singh', 5, 'deepika.singh@gmail.com'),
('t105', 'Rahul Verma', 6, 'rahul.verma@gmail.com'),
('t106', 'Pooja Gupta', 7, 'pooja.gupta@gmail.com'),
('t107', 'Vikram Singh', 3, 'vikram.singh@gmail.com'),
('t108', 'Aarti Desai', 1, 'aarti.desai@gmail.com'),
('t109', 'Arjun Kapoor', 2, 'arjun.kapoor@gmail.com'),
('t110', 'Nisha Metha', 2, 'nisha.metha@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `STUDID` varchar(10) DEFAULT NULL,
  `NAME` varchar(30) DEFAULT NULL,
  `DEPID` int(11) DEFAULT NULL,
  `EMAIL` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`STUDID`, `NAME`, `DEPID`, `EMAIL`) VALUES
('s114', 'Alec Sidden', 1, 'asiddend@college.com'),
('s105', 'Burr Matusiak', 1, 'bmatusiak4@college.com'),
('s111', 'Bronnie Theuss', 2, 'btheussa@college.com'),
('s104', 'Darcee Moulsdall', 3, 'dmoulsdall3@college.com'),
('s113', 'Danit Valiant', 1, 'dvaliantc@college.com'),
('s103', 'Ericka Steinham', 7, 'esteinham2@college.com'),
('s101', 'Felic Helis', 2, 'fhelis0@college.com'),
('s108', 'Hamlin Moreby', 1, 'hmoreby7@college.com'),
('s115', 'Heindrick Stubbings', 5, 'hstubbingse@college.com'),
('s118', 'Kelley Labbey', 6, 'klabbeyh@college.com'),
('s107', 'Martie Dallman', 6, 'mdallman6@college.com'),
('s116', 'Micheal Gash', 4, 'mgashf@college.com'),
('s109', 'Melodee Lehr', 5, 'mlehr8@college.com'),
('s102', 'Micheal Prendergrast', 2, 'mprendergrast1@college.com'),
('s110', 'Saree Barmby', 1, 'sbarmby9@college.com'),
('s117', 'Sheryl Peak', 4, 'speakg@college.com'),
('s112', 'Tim McComas', 5, 'tmccomasb@college.com'),
('s119', 'Tootsie Petyankin', 7, 'tpetyankini@college.com'),
('s120', 'Vivianne Batrick', 2, 'vbatrickj@college.com'),
('s106', 'Vladamir Morrieson', 4, 'vmorrieson5@college.com');

-- --------------------------------------------------------

--
-- Table structure for table `subject`
--

CREATE TABLE `subject` (
  `SUBID` int(11) NOT NULL,
  `NAME` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `subject`
--

INSERT INTO `subject` (`SUBID`, `NAME`) VALUES
(1, 'LAUC'),
(2, 'BEEE'),
(3, 'CHEM'),
(4, 'FPL1'),
(5, 'FPL2'),
(6, 'SE'),
(7, 'GI'),
(8, 'EG'),
(9, 'PHY'),
(10, 'MVC'),
(11, 'DS'),
(12, 'DM'),
(13, 'PP'),
(14, 'UHV2'),
(15, 'DSCO'),
(16, 'DMS'),
(17, 'OS'),
(18, 'TOC'),
(19, 'ML'),
(20, 'C&S');

-- --------------------------------------------------------

--
-- Table structure for table `teaching_staff`
--

CREATE TABLE `teaching_staff` (
  `ID` varchar(10) DEFAULT NULL,
  `SUBID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teaching_staff`
--

INSERT INTO `teaching_staff` (`ID`, `SUBID`) VALUES
('t101', 1),
('t102', 5),
('t103', 10),
('t104', 15),
('t105', 3),
('t106', 8),
('t107', 17),
('t108', 6),
('t109', 12),
('t110', 20);

-- --------------------------------------------------------

--
-- Table structure for table `textbooks`
--

CREATE TABLE `textbooks` (
  `BOOKID` int(11) DEFAULT NULL,
  `AUTHOR` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `textbooks`
--

INSERT INTO `textbooks` (`BOOKID`, `AUTHOR`) VALUES
(1, 'Abraham Silberschatz, Henry F. Korth, S. Sudarshan'),
(2, 'Abraham Silberschatz, Peter B. Galvin, Greg Gagne'),
(3, 'John F. Wakerly'),
(4, 'James W. Nilsson, Susan A. Riedel'),
(5, 'James Stewart'),
(6, 'J.M. Smith, H.C. Van Ness, M.M. Abbott'),
(7, 'Christopher M. Bishop'),
(8, 'John J. Craig'),
(9, 'Michael L. Scott'),
(10, 'W. Mark Saltzman'),
(11, 'Joseph E. Shigley, Charles R. Mischke'),
(12, 'Russell C. Hibbeler'),
(13, 'David Halliday, Robert Resnick, Jearl Walker'),
(14, 'John D. Anderson Jr.'),
(15, 'David A. Patterson, John L. Hennessy'),
(16, 'William Stallings'),
(17, 'Mackenzie Davis, David Cornwell'),
(18, 'Ronald E. Terry, J. Brandon Rogers'),
(19, 'John J. Craig'),
(20, 'Thomas H. Cormen, Charles E. Leiserson, Ronald L. Rivest, Clifford Stein');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `UserID` int(11) NOT NULL,
  `RegID` varchar(10) DEFAULT NULL,
  `Type` varchar(50) DEFAULT '',
  `Password` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`UserID`, `RegID`, `Type`, `Password`) VALUES
(1, 'n101', 'NonTeaching', 'trial*pswd123'),
(2, 't101', 'Teaching', 'pswdtr23'),
(3, 't104', 'Teaching', 'cL8{e9O~iEu3YcB'),
(4, 't105', 'Teaching', 'qN6#<(ddSx%'),
(5, 's101', 'Student', 'jF7~*2B`Iw{yBZ,736I.'),
(6, 's102', 'Student', 'lN5>yYLpVdQ\'~d|/3(\','),
(7, 's103', 'Student', 'jO6<fq3q\"5Wq=ZFFw'),
(8, 's104', 'Student', 'dI2\"dqJGMdt{~'),
(9, 't102', 'Teaching', 'wI8/idoh\'&MXoV_)p0YQ'),
(10, 't103', 'Teaching', 'dZ9?95x_n5yVh7BTH+}'),
(11, 'n110', 'NonTeaching', 'mX1*7O41Ul759UkB'),
(12, 'n102', 'NonTeaching', 'qE3=~lXn%E=$(Y`/J'),
(13, 't106', 'Teaching', 'eQ4`\"=$k$6wpjB=M'),
(14, 's113', 'Student', 'hK3@_dhKKHT|z5'),
(15, 's116', 'Student', 'oT6=I=X\'>0L%'),
(16, 't108', 'Teaching', 'gU6~%3,b1v1}F1nD7q9'),
(17, 't109', 'Teaching', 'kK3_|u!5/Vks0cPf6'),
(18, 's119', 'Student', 'vN6~oufVAm2_7'),
(19, 's105', 'Student', 'uL8/ubuSwgIJB}c{w<r'),
(20, 's107', 'Student', 'eJ2/!4HtJ#h(TS'),
(21, 'n104', 'NonTeaching', 'tN3&v@$|b$e'),
(22, 't107', 'Teaching', 'hD5|Hkr@?,A\'f)y'),
(23, 'admin', 'NonTeaching', 'admin123');

--
-- Triggers `users`
--
DELIMITER $$
CREATE TRIGGER `useraddition` BEFORE INSERT ON `users` FOR EACH ROW BEGIN
    DECLARE errormsg VARCHAR(100) DEFAULT 'Valid user added'; 
    
    IF NEW.RegID NOT IN (SELECT ID FROM staff) AND NEW.RegID NOT IN (SELECT STUDID FROM students) THEN
        SET errormsg = 'INVALID USER';
    END IF;
    
    IF errormsg = 'INVALID USER' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormsg;
     ELSE 
     	SET NEW.Type = (CASE
    		WHEN NEW.RegID LIKE 'n%' THEN 'NonTeaching'
            WHEN NEW.RegID LIKE 't%' THEN 'Teaching'
            ELSE 'Student' END);

    END IF;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`BOOKID`),
  ADD KEY `PID` (`PID`);

--
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`depid`);

--
-- Indexes for table `issues`
--
ALTER TABLE `issues`
  ADD PRIMARY KEY (`issueID`),
  ADD UNIQUE KEY `uniqueIssue` (`BOOKID`,`USERID`);

--
-- Indexes for table `journals`
--
ALTER TABLE `journals`
  ADD KEY `BOOKID` (`BOOKID`);

--
-- Indexes for table `non_teaching_staff`
--
ALTER TABLE `non_teaching_staff`
  ADD KEY `ID` (`ID`);

--
-- Indexes for table `novel`
--
ALTER TABLE `novel`
  ADD KEY `BOOKID` (`BOOKID`);

--
-- Indexes for table `publisher`
--
ALTER TABLE `publisher`
  ADD PRIMARY KEY (`PID`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD UNIQUE KEY `EMAIL` (`EMAIL`);

--
-- Indexes for table `subject`
--
ALTER TABLE `subject`
  ADD PRIMARY KEY (`SUBID`);

--
-- Indexes for table `teaching_staff`
--
ALTER TABLE `teaching_staff`
  ADD KEY `ID` (`ID`);

--
-- Indexes for table `textbooks`
--
ALTER TABLE `textbooks`
  ADD KEY `BOOKID` (`BOOKID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`UserID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `books`
--
ALTER TABLE `books`
  MODIFY `BOOKID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=131;

--
-- AUTO_INCREMENT for table `issues`
--
ALTER TABLE `issues`
  MODIFY `issueID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `publisher`
--
ALTER TABLE `publisher`
  MODIFY `PID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `books`
--
ALTER TABLE `books`
  ADD CONSTRAINT `books_ibfk_1` FOREIGN KEY (`PID`) REFERENCES `publisher` (`PID`);

--
-- Constraints for table `journals`
--
ALTER TABLE `journals`
  ADD CONSTRAINT `journals_ibfk_1` FOREIGN KEY (`BOOKID`) REFERENCES `books` (`BOOKID`);

--
-- Constraints for table `non_teaching_staff`
--
ALTER TABLE `non_teaching_staff`
  ADD CONSTRAINT `non_teaching_staff_ibfk_1` FOREIGN KEY (`ID`) REFERENCES `staff` (`ID`);

--
-- Constraints for table `novel`
--
ALTER TABLE `novel`
  ADD CONSTRAINT `novel_ibfk_1` FOREIGN KEY (`BOOKID`) REFERENCES `books` (`BOOKID`);

--
-- Constraints for table `teaching_staff`
--
ALTER TABLE `teaching_staff`
  ADD CONSTRAINT `teaching_staff_ibfk_1` FOREIGN KEY (`ID`) REFERENCES `staff` (`ID`);

--
-- Constraints for table `textbooks`
--
ALTER TABLE `textbooks`
  ADD CONSTRAINT `textbooks_ibfk_1` FOREIGN KEY (`BOOKID`) REFERENCES `books` (`BOOKID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
