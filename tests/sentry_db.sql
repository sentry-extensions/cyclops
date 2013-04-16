-- MySQL dump 10.13  Distrib 5.6.10, for osx10.8 (x86_64)
--
-- Host: localhost    Database: sentry
-- ------------------------------------------------------
-- Server version	5.6.10

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_id` (`group_id`,`permission_id`),
  KEY `auth_group_permissions_bda51c3c` (`group_id`),
  KEY `auth_group_permissions_1e014c8f` (`permission_id`),
  CONSTRAINT `group_id_refs_id_3cea63fe` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `permission_id_refs_id_a7792de1` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `content_type_id` (`content_type_id`,`codename`),
  KEY `auth_permission_e4470c6e` (`content_type_id`),
  CONSTRAINT `content_type_id_refs_id_728de91f` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=149 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add permission',1,'add_permission'),(2,'Can change permission',1,'change_permission'),(3,'Can delete permission',1,'delete_permission'),(4,'Can add group',2,'add_group'),(5,'Can change group',2,'change_group'),(6,'Can delete group',2,'delete_group'),(7,'Can add user',3,'add_user'),(8,'Can change user',3,'change_user'),(9,'Can delete user',3,'delete_user'),(10,'Can add log entry',4,'add_logentry'),(11,'Can change log entry',4,'change_logentry'),(12,'Can delete log entry',4,'delete_logentry'),(13,'Can add content type',5,'add_contenttype'),(14,'Can change content type',5,'change_contenttype'),(15,'Can delete content type',5,'delete_contenttype'),(16,'Can add session',6,'add_session'),(17,'Can change session',6,'change_session'),(18,'Can delete session',6,'delete_session'),(19,'Can add site',7,'add_site'),(20,'Can change site',7,'change_site'),(21,'Can delete site',7,'delete_site'),(22,'Can add migration history',8,'add_migrationhistory'),(23,'Can change migration history',8,'change_migrationhistory'),(24,'Can delete migration history',8,'delete_migrationhistory'),(25,'Can add task state',9,'add_taskmeta'),(26,'Can change task state',9,'change_taskmeta'),(27,'Can delete task state',9,'delete_taskmeta'),(28,'Can add saved group result',10,'add_tasksetmeta'),(29,'Can change saved group result',10,'change_tasksetmeta'),(30,'Can delete saved group result',10,'delete_tasksetmeta'),(31,'Can add interval',11,'add_intervalschedule'),(32,'Can change interval',11,'change_intervalschedule'),(33,'Can delete interval',11,'delete_intervalschedule'),(34,'Can add crontab',12,'add_crontabschedule'),(35,'Can change crontab',12,'change_crontabschedule'),(36,'Can delete crontab',12,'delete_crontabschedule'),(37,'Can add periodic tasks',13,'add_periodictasks'),(38,'Can change periodic tasks',13,'change_periodictasks'),(39,'Can delete periodic tasks',13,'delete_periodictasks'),(40,'Can add periodic task',14,'add_periodictask'),(41,'Can change periodic task',14,'change_periodictask'),(42,'Can delete periodic task',14,'delete_periodictask'),(43,'Can add worker',15,'add_workerstate'),(44,'Can change worker',15,'change_workerstate'),(45,'Can delete worker',15,'delete_workerstate'),(46,'Can add task',16,'add_taskstate'),(47,'Can change task',16,'change_taskstate'),(48,'Can delete task',16,'delete_taskstate'),(49,'Can add queue',17,'add_queue'),(50,'Can change queue',17,'change_queue'),(51,'Can delete queue',17,'delete_queue'),(52,'Can add message',18,'add_message'),(53,'Can change message',18,'change_message'),(54,'Can delete message',18,'delete_message'),(55,'Can add option',19,'add_option'),(56,'Can change option',19,'change_option'),(57,'Can delete option',19,'delete_option'),(58,'Can add team',20,'add_team'),(59,'Can change team',20,'change_team'),(60,'Can delete team',20,'delete_team'),(61,'Can add access group',21,'add_accessgroup'),(62,'Can change access group',21,'change_accessgroup'),(63,'Can delete access group',21,'delete_accessgroup'),(64,'Can add team member',22,'add_teammember'),(65,'Can change team member',22,'change_teammember'),(66,'Can delete team member',22,'delete_teammember'),(67,'Can add project',23,'add_project'),(68,'Can change project',23,'change_project'),(69,'Can delete project',23,'delete_project'),(70,'Can add project key',24,'add_projectkey'),(71,'Can change project key',24,'change_projectkey'),(72,'Can delete project key',24,'delete_projectkey'),(73,'Can add project option',25,'add_projectoption'),(74,'Can change project option',25,'change_projectoption'),(75,'Can delete project option',25,'delete_projectoption'),(76,'Can add pending team member',26,'add_pendingteammember'),(77,'Can change pending team member',26,'change_pendingteammember'),(78,'Can delete pending team member',26,'delete_pendingteammember'),(79,'Can add grouped message',27,'add_group'),(80,'Can change grouped message',27,'change_group'),(81,'Can delete grouped message',27,'delete_group'),(82,'Can view',27,'can_view'),(83,'Can add group meta',28,'add_groupmeta'),(84,'Can change group meta',28,'change_groupmeta'),(85,'Can delete group meta',28,'delete_groupmeta'),(86,'Can add message',29,'add_event'),(87,'Can change message',29,'change_event'),(88,'Can delete message',29,'delete_event'),(89,'Can add group bookmark',30,'add_groupbookmark'),(90,'Can change group bookmark',30,'change_groupbookmark'),(91,'Can delete group bookmark',30,'delete_groupbookmark'),(92,'Can add filter key',31,'add_filterkey'),(93,'Can change filter key',31,'change_filterkey'),(94,'Can delete filter key',31,'delete_filterkey'),(95,'Can add filter value',32,'add_filtervalue'),(96,'Can change filter value',32,'change_filtervalue'),(97,'Can delete filter value',32,'delete_filtervalue'),(98,'Can add group tag key',33,'add_grouptagkey'),(99,'Can change group tag key',33,'change_grouptagkey'),(100,'Can delete group tag key',33,'delete_grouptagkey'),(101,'Can add group tag',34,'add_grouptag'),(102,'Can change group tag',34,'change_grouptag'),(103,'Can delete group tag',34,'delete_grouptag'),(104,'Can add group count by minute',35,'add_groupcountbyminute'),(105,'Can change group count by minute',35,'change_groupcountbyminute'),(106,'Can delete group count by minute',35,'delete_groupcountbyminute'),(107,'Can add project count by minute',36,'add_projectcountbyminute'),(108,'Can change project count by minute',36,'change_projectcountbyminute'),(109,'Can delete project count by minute',36,'delete_projectcountbyminute'),(110,'Can add search document',37,'add_searchdocument'),(111,'Can change search document',37,'change_searchdocument'),(112,'Can delete search document',37,'delete_searchdocument'),(113,'Can add search token',38,'add_searchtoken'),(114,'Can change search token',38,'change_searchtoken'),(115,'Can delete search token',38,'delete_searchtoken'),(116,'Can add user option',39,'add_useroption'),(117,'Can change user option',39,'change_useroption'),(118,'Can delete user option',39,'delete_useroption'),(119,'Can add lost password hash',40,'add_lostpasswordhash'),(120,'Can change lost password hash',40,'change_lostpasswordhash'),(121,'Can delete lost password hash',40,'delete_lostpasswordhash'),(122,'Can add tracked user',41,'add_trackeduser'),(123,'Can change tracked user',41,'change_trackeduser'),(124,'Can delete tracked user',41,'delete_trackeduser'),(125,'Can add affected user by group',42,'add_affecteduserbygroup'),(126,'Can change affected user by group',42,'change_affecteduserbygroup'),(127,'Can delete affected user by group',42,'delete_affecteduserbygroup'),(128,'Can add activity',43,'add_activity'),(129,'Can change activity',43,'change_activity'),(130,'Can delete activity',43,'delete_activity'),(131,'Can add alert',44,'add_alert'),(132,'Can change alert',44,'change_alert'),(133,'Can delete alert',44,'delete_alert'),(134,'Can add alert related group',45,'add_alertrelatedgroup'),(135,'Can change alert related group',45,'change_alertrelatedgroup'),(136,'Can delete alert related group',45,'delete_alertrelatedgroup'),(137,'Can add message index',46,'add_messageindex'),(138,'Can change message index',46,'change_messageindex'),(139,'Can delete message index',46,'delete_messageindex'),(140,'Can add user social auth',47,'add_usersocialauth'),(141,'Can change user social auth',47,'change_usersocialauth'),(142,'Can delete user social auth',47,'delete_usersocialauth'),(143,'Can add nonce',48,'add_nonce'),(144,'Can change nonce',48,'change_nonce'),(145,'Can delete nonce',48,'delete_nonce'),(146,'Can add association',49,'add_association'),(147,'Can change association',49,'change_association'),(148,'Can delete association',49,'delete_association');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(75) NOT NULL,
  `password` varchar(128) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `last_login` datetime NOT NULL,
  `date_joined` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'admin','','','admin@admin.com','bc$$2a$12$P73gRvP.RaunwuY1WiWN2eLG3mXOK6FA9yc6GR9ilm5d5sIM6pJeq',1,1,1,'2013-04-12 14:35:53','2013-04-12 14:35:53');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`group_id`),
  KEY `auth_user_groups_fbfc09f1` (`user_id`),
  KEY `auth_user_groups_bda51c3c` (`group_id`),
  CONSTRAINT `user_id_refs_id_831107f1` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `group_id_refs_id_f0ee9890` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`permission_id`),
  KEY `auth_user_user_permissions_fbfc09f1` (`user_id`),
  KEY `auth_user_user_permissions_1e014c8f` (`permission_id`),
  CONSTRAINT `user_id_refs_id_f2045483` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `permission_id_refs_id_67e79cb` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `celery_taskmeta`
--

DROP TABLE IF EXISTS `celery_taskmeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `celery_taskmeta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task_id` varchar(255) NOT NULL,
  `status` varchar(50) NOT NULL,
  `result` longtext,
  `date_done` datetime NOT NULL,
  `traceback` longtext,
  `hidden` tinyint(1) NOT NULL,
  `meta` longtext,
  PRIMARY KEY (`id`),
  UNIQUE KEY `task_id` (`task_id`),
  KEY `celery_taskmeta_c91f1bf` (`hidden`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `celery_taskmeta`
--

LOCK TABLES `celery_taskmeta` WRITE;
/*!40000 ALTER TABLE `celery_taskmeta` DISABLE KEYS */;
/*!40000 ALTER TABLE `celery_taskmeta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `celery_tasksetmeta`
--

DROP TABLE IF EXISTS `celery_tasksetmeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `celery_tasksetmeta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `taskset_id` varchar(255) NOT NULL,
  `result` longtext NOT NULL,
  `date_done` datetime NOT NULL,
  `hidden` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `taskset_id` (`taskset_id`),
  KEY `celery_tasksetmeta_c91f1bf` (`hidden`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `celery_tasksetmeta`
--

LOCK TABLES `celery_tasksetmeta` WRITE;
/*!40000 ALTER TABLE `celery_tasksetmeta` DISABLE KEYS */;
/*!40000 ALTER TABLE `celery_tasksetmeta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime NOT NULL,
  `user_id` int(11) NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_fbfc09f1` (`user_id`),
  KEY `django_admin_log_e4470c6e` (`content_type_id`),
  CONSTRAINT `content_type_id_refs_id_288599e6` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `user_id_refs_id_c8665aa` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_label` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'permission','auth','permission'),(2,'group','auth','group'),(3,'user','auth','user'),(4,'log entry','admin','logentry'),(5,'content type','contenttypes','contenttype'),(6,'session','sessions','session'),(7,'site','sites','site'),(8,'migration history','south','migrationhistory'),(9,'task state','djcelery','taskmeta'),(10,'saved group result','djcelery','tasksetmeta'),(11,'interval','djcelery','intervalschedule'),(12,'crontab','djcelery','crontabschedule'),(13,'periodic tasks','djcelery','periodictasks'),(14,'periodic task','djcelery','periodictask'),(15,'worker','djcelery','workerstate'),(16,'task','djcelery','taskstate'),(17,'queue','django','queue'),(18,'message','django','message'),(19,'option','sentry','option'),(20,'team','sentry','team'),(21,'access group','sentry','accessgroup'),(22,'team member','sentry','teammember'),(23,'project','sentry','project'),(24,'project key','sentry','projectkey'),(25,'project option','sentry','projectoption'),(26,'pending team member','sentry','pendingteammember'),(27,'grouped message','sentry','group'),(28,'group meta','sentry','groupmeta'),(29,'message','sentry','event'),(30,'group bookmark','sentry','groupbookmark'),(31,'filter key','sentry','filterkey'),(32,'filter value','sentry','filtervalue'),(33,'group tag key','sentry','grouptagkey'),(34,'group tag','sentry','grouptag'),(35,'group count by minute','sentry','groupcountbyminute'),(36,'project count by minute','sentry','projectcountbyminute'),(37,'search document','sentry','searchdocument'),(38,'search token','sentry','searchtoken'),(39,'user option','sentry','useroption'),(40,'lost password hash','sentry','lostpasswordhash'),(41,'tracked user','sentry','trackeduser'),(42,'affected user by group','sentry','affecteduserbygroup'),(43,'activity','sentry','activity'),(44,'alert','sentry','alert'),(45,'alert related group','sentry','alertrelatedgroup'),(46,'message index','sentry','messageindex'),(47,'user social auth','social_auth','usersocialauth'),(48,'nonce','social_auth','nonce'),(49,'association','social_auth','association');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_c25c2c28` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_site`
--

DROP TABLE IF EXISTS `django_site`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_site` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(100) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_site`
--

LOCK TABLES `django_site` WRITE;
/*!40000 ALTER TABLE `django_site` DISABLE KEYS */;
INSERT INTO `django_site` VALUES (1,'example.com','example.com');
/*!40000 ALTER TABLE `django_site` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `djcelery_crontabschedule`
--

DROP TABLE IF EXISTS `djcelery_crontabschedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `djcelery_crontabschedule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `minute` varchar(64) NOT NULL,
  `hour` varchar(64) NOT NULL,
  `day_of_week` varchar(64) NOT NULL,
  `day_of_month` varchar(64) NOT NULL,
  `month_of_year` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `djcelery_crontabschedule`
--

LOCK TABLES `djcelery_crontabschedule` WRITE;
/*!40000 ALTER TABLE `djcelery_crontabschedule` DISABLE KEYS */;
/*!40000 ALTER TABLE `djcelery_crontabschedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `djcelery_intervalschedule`
--

DROP TABLE IF EXISTS `djcelery_intervalschedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `djcelery_intervalschedule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `every` int(11) NOT NULL,
  `period` varchar(24) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `djcelery_intervalschedule`
--

LOCK TABLES `djcelery_intervalschedule` WRITE;
/*!40000 ALTER TABLE `djcelery_intervalschedule` DISABLE KEYS */;
/*!40000 ALTER TABLE `djcelery_intervalschedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `djcelery_periodictask`
--

DROP TABLE IF EXISTS `djcelery_periodictask`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `djcelery_periodictask` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `task` varchar(200) NOT NULL,
  `interval_id` int(11) DEFAULT NULL,
  `crontab_id` int(11) DEFAULT NULL,
  `args` longtext NOT NULL,
  `kwargs` longtext NOT NULL,
  `queue` varchar(200) DEFAULT NULL,
  `exchange` varchar(200) DEFAULT NULL,
  `routing_key` varchar(200) DEFAULT NULL,
  `expires` datetime DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL,
  `last_run_at` datetime DEFAULT NULL,
  `total_run_count` int(10) unsigned NOT NULL,
  `date_changed` datetime NOT NULL,
  `description` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `djcelery_periodictask_17d2d99d` (`interval_id`),
  KEY `djcelery_periodictask_7aa5fda` (`crontab_id`),
  CONSTRAINT `crontab_id_refs_id_2c92a393ebff5e74` FOREIGN KEY (`crontab_id`) REFERENCES `djcelery_crontabschedule` (`id`),
  CONSTRAINT `interval_id_refs_id_672c7616f2054349` FOREIGN KEY (`interval_id`) REFERENCES `djcelery_intervalschedule` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `djcelery_periodictask`
--

LOCK TABLES `djcelery_periodictask` WRITE;
/*!40000 ALTER TABLE `djcelery_periodictask` DISABLE KEYS */;
/*!40000 ALTER TABLE `djcelery_periodictask` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `djcelery_periodictasks`
--

DROP TABLE IF EXISTS `djcelery_periodictasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `djcelery_periodictasks` (
  `ident` smallint(6) NOT NULL,
  `last_update` datetime NOT NULL,
  PRIMARY KEY (`ident`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `djcelery_periodictasks`
--

LOCK TABLES `djcelery_periodictasks` WRITE;
/*!40000 ALTER TABLE `djcelery_periodictasks` DISABLE KEYS */;
/*!40000 ALTER TABLE `djcelery_periodictasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `djcelery_taskstate`
--

DROP TABLE IF EXISTS `djcelery_taskstate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `djcelery_taskstate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `state` varchar(64) NOT NULL,
  `task_id` varchar(36) NOT NULL,
  `name` varchar(200) DEFAULT NULL,
  `tstamp` datetime NOT NULL,
  `args` longtext,
  `kwargs` longtext,
  `eta` datetime DEFAULT NULL,
  `expires` datetime DEFAULT NULL,
  `result` longtext,
  `traceback` longtext,
  `runtime` double DEFAULT NULL,
  `retries` int(11) NOT NULL,
  `worker_id` int(11) DEFAULT NULL,
  `hidden` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `task_id` (`task_id`),
  KEY `djcelery_taskstate_355bfc27` (`state`),
  KEY `djcelery_taskstate_52094d6e` (`name`),
  KEY `djcelery_taskstate_f0ba6500` (`tstamp`),
  KEY `djcelery_taskstate_20fc5b84` (`worker_id`),
  KEY `djcelery_taskstate_c91f1bf` (`hidden`),
  CONSTRAINT `worker_id_refs_id_13af6e2204e3453a` FOREIGN KEY (`worker_id`) REFERENCES `djcelery_workerstate` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `djcelery_taskstate`
--

LOCK TABLES `djcelery_taskstate` WRITE;
/*!40000 ALTER TABLE `djcelery_taskstate` DISABLE KEYS */;
/*!40000 ALTER TABLE `djcelery_taskstate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `djcelery_workerstate`
--

DROP TABLE IF EXISTS `djcelery_workerstate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `djcelery_workerstate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hostname` varchar(255) NOT NULL,
  `last_heartbeat` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hostname` (`hostname`),
  KEY `djcelery_workerstate_eb8ac7e4` (`last_heartbeat`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `djcelery_workerstate`
--

LOCK TABLES `djcelery_workerstate` WRITE;
/*!40000 ALTER TABLE `djcelery_workerstate` DISABLE KEYS */;
/*!40000 ALTER TABLE `djcelery_workerstate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `djkombu_message`
--

DROP TABLE IF EXISTS `djkombu_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `djkombu_message` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `visible` tinyint(1) NOT NULL,
  `sent_at` datetime DEFAULT NULL,
  `payload` longtext NOT NULL,
  `queue_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `djkombu_message_e94d8f76` (`visible`),
  KEY `djkombu_message_88b78e52` (`sent_at`),
  KEY `djkombu_message_e18d2948` (`queue_id`),
  CONSTRAINT `queue_id_refs_id_7f11668913f7812d` FOREIGN KEY (`queue_id`) REFERENCES `djkombu_queue` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `djkombu_message`
--

LOCK TABLES `djkombu_message` WRITE;
/*!40000 ALTER TABLE `djkombu_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `djkombu_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `djkombu_queue`
--

DROP TABLE IF EXISTS `djkombu_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `djkombu_queue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `djkombu_queue`
--

LOCK TABLES `djkombu_queue` WRITE;
/*!40000 ALTER TABLE `djkombu_queue` DISABLE KEYS */;
/*!40000 ALTER TABLE `djkombu_queue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_accessgroup`
--

DROP TABLE IF EXISTS `sentry_accessgroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_accessgroup` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `team_id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `type` int(11) NOT NULL,
  `managed` tinyint(1) NOT NULL,
  `data` longtext,
  `date_added` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sentry_accessgroup_team_id_2b24bc5cfcd1a84_uniq` (`team_id`,`name`),
  KEY `sentry_accessgroup_fcf8ac47` (`team_id`),
  CONSTRAINT `team_id_refs_id_58360300e4684992` FOREIGN KEY (`team_id`) REFERENCES `sentry_team` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_accessgroup`
--

LOCK TABLES `sentry_accessgroup` WRITE;
/*!40000 ALTER TABLE `sentry_accessgroup` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_accessgroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_accessgroup_members`
--

DROP TABLE IF EXISTS `sentry_accessgroup_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_accessgroup_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accessgroup_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sentry_accessgroup_members_accessgroup_id_18b186be5753dc4e_uniq` (`accessgroup_id`,`user_id`),
  KEY `sentry_accessgroup_members_a1546620` (`accessgroup_id`),
  KEY `sentry_accessgroup_members_fbfc09f1` (`user_id`),
  CONSTRAINT `accessgroup_id_refs_id_3b1d573e2190e19f` FOREIGN KEY (`accessgroup_id`) REFERENCES `sentry_accessgroup` (`id`),
  CONSTRAINT `user_id_refs_id_3d2afcee6ee584fd` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_accessgroup_members`
--

LOCK TABLES `sentry_accessgroup_members` WRITE;
/*!40000 ALTER TABLE `sentry_accessgroup_members` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_accessgroup_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_accessgroup_projects`
--

DROP TABLE IF EXISTS `sentry_accessgroup_projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_accessgroup_projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accessgroup_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sentry_accessgroup_project_accessgroup_id_16d324e6ca4c312f_uniq` (`accessgroup_id`,`project_id`),
  KEY `sentry_accessgroup_projects_a1546620` (`accessgroup_id`),
  KEY `sentry_accessgroup_projects_b6620684` (`project_id`),
  CONSTRAINT `accessgroup_id_refs_id_496c83cd76c533cd` FOREIGN KEY (`accessgroup_id`) REFERENCES `sentry_accessgroup` (`id`),
  CONSTRAINT `project_id_refs_id_f120886aeaa031` FOREIGN KEY (`project_id`) REFERENCES `sentry_project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_accessgroup_projects`
--

LOCK TABLES `sentry_accessgroup_projects` WRITE;
/*!40000 ALTER TABLE `sentry_accessgroup_projects` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_accessgroup_projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_activity`
--

DROP TABLE IF EXISTS `sentry_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_activity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `group_id` int(11) DEFAULT NULL,
  `event_id` int(11) DEFAULT NULL,
  `type` int(10) unsigned NOT NULL,
  `ident` varchar(64) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `datetime` datetime NOT NULL,
  `data` longtext,
  PRIMARY KEY (`id`),
  KEY `sentry_activity_b6620684` (`project_id`),
  KEY `sentry_activity_bda51c3c` (`group_id`),
  KEY `sentry_activity_e9b82f95` (`event_id`),
  KEY `sentry_activity_fbfc09f1` (`user_id`),
  CONSTRAINT `project_id_refs_id_61fef119c922ad48` FOREIGN KEY (`project_id`) REFERENCES `sentry_project` (`id`),
  CONSTRAINT `group_id_refs_id_17ce198a23ebc6df` FOREIGN KEY (`group_id`) REFERENCES `sentry_groupedmessage` (`id`),
  CONSTRAINT `event_id_refs_id_3fda87e90c9e5a46` FOREIGN KEY (`event_id`) REFERENCES `sentry_message` (`id`),
  CONSTRAINT `user_id_refs_id_4216af41800dc560` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_activity`
--

LOCK TABLES `sentry_activity` WRITE;
/*!40000 ALTER TABLE `sentry_activity` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_activity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_affecteduserbygroup`
--

DROP TABLE IF EXISTS `sentry_affecteduserbygroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_affecteduserbygroup` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `ident` varchar(200),
  `times_seen` int(10) unsigned NOT NULL,
  `last_seen` datetime NOT NULL,
  `first_seen` datetime NOT NULL,
  `tuser_id` int(11),
  PRIMARY KEY (`id`),
  UNIQUE KEY `sentry_affecteduserbygroup_project_id_6b23f02b1aa731c7_uniq` (`project_id`,`tuser_id`,`group_id`),
  KEY `sentry_affecteduserbygroup_b6620684` (`project_id`),
  KEY `sentry_affecteduserbygroup_bda51c3c` (`group_id`),
  KEY `sentry_affecteduserbygroup_ee4a0d0` (`last_seen`),
  KEY `sentry_affecteduserbygroup_4d23e6a1` (`first_seen`),
  KEY `sentry_affecteduserbygroup_508568a8` (`tuser_id`),
  CONSTRAINT `group_id_refs_id_7a64ef42de72b330` FOREIGN KEY (`group_id`) REFERENCES `sentry_groupedmessage` (`id`),
  CONSTRAINT `project_id_refs_id_76af0a75618e4457` FOREIGN KEY (`project_id`) REFERENCES `sentry_project` (`id`),
  CONSTRAINT `tuser_id_refs_id_cc4a7a9674482bf` FOREIGN KEY (`tuser_id`) REFERENCES `sentry_trackeduser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_affecteduserbygroup`
--

LOCK TABLES `sentry_affecteduserbygroup` WRITE;
/*!40000 ALTER TABLE `sentry_affecteduserbygroup` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_affecteduserbygroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_alert`
--

DROP TABLE IF EXISTS `sentry_alert`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_alert` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `group_id` int(11) DEFAULT NULL,
  `datetime` datetime NOT NULL,
  `message` longtext NOT NULL,
  `data` longtext,
  PRIMARY KEY (`id`),
  KEY `sentry_alert_b6620684` (`project_id`),
  KEY `sentry_alert_bda51c3c` (`group_id`),
  CONSTRAINT `project_id_refs_id_31028beae2c41bde` FOREIGN KEY (`project_id`) REFERENCES `sentry_project` (`id`),
  CONSTRAINT `group_id_refs_id_5c0729274bce2849` FOREIGN KEY (`group_id`) REFERENCES `sentry_groupedmessage` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_alert`
--

LOCK TABLES `sentry_alert` WRITE;
/*!40000 ALTER TABLE `sentry_alert` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_alert` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_alertrelatedgroup`
--

DROP TABLE IF EXISTS `sentry_alertrelatedgroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_alertrelatedgroup` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `alert_id` int(11) NOT NULL,
  `data` longtext,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sentry_alertrelatedgroup_group_id_50403ae25779becb_uniq` (`group_id`,`alert_id`),
  KEY `sentry_alertrelatedgroup_bda51c3c` (`group_id`),
  KEY `sentry_alertrelatedgroup_296fd947` (`alert_id`),
  CONSTRAINT `group_id_refs_id_272aa491c5dd00f1` FOREIGN KEY (`group_id`) REFERENCES `sentry_groupedmessage` (`id`),
  CONSTRAINT `alert_id_refs_id_402a1f70c302970f` FOREIGN KEY (`alert_id`) REFERENCES `sentry_alert` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_alertrelatedgroup`
--

LOCK TABLES `sentry_alertrelatedgroup` WRITE;
/*!40000 ALTER TABLE `sentry_alertrelatedgroup` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_alertrelatedgroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_filterkey`
--

DROP TABLE IF EXISTS `sentry_filterkey`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_filterkey` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `key` varchar(32) NOT NULL,
  `values_seen` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sentry_filterkey_project_id_67551b8e28dda5a_uniq` (`project_id`,`key`),
  KEY `sentry_filterkey_b6620684` (`project_id`),
  CONSTRAINT `project_id_refs_id_dab2b4f870902f3` FOREIGN KEY (`project_id`) REFERENCES `sentry_project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_filterkey`
--

LOCK TABLES `sentry_filterkey` WRITE;
/*!40000 ALTER TABLE `sentry_filterkey` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_filterkey` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_filtervalue`
--

DROP TABLE IF EXISTS `sentry_filtervalue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_filtervalue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(32) NOT NULL,
  `value` varchar(200) NOT NULL,
  `project_id` int(11),
  `times_seen` int(10) unsigned NOT NULL,
  `last_seen` datetime,
  `first_seen` datetime,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sentry_filtervalue_project_id_201b156195347397_uniq` (`project_id`,`key`,`value`),
  KEY `sentry_filtervalue_b6620684` (`project_id`),
  KEY `sentry_filtervalue_ee4a0d0` (`last_seen`),
  KEY `sentry_filtervalue_4d23e6a1` (`first_seen`),
  CONSTRAINT `project_id_refs_id_3a69ccd650618575` FOREIGN KEY (`project_id`) REFERENCES `sentry_project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_filtervalue`
--

LOCK TABLES `sentry_filtervalue` WRITE;
/*!40000 ALTER TABLE `sentry_filtervalue` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_filtervalue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_groupbookmark`
--

DROP TABLE IF EXISTS `sentry_groupbookmark`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_groupbookmark` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sentry_groupbookmark_project_id_6d2bb88ad3832208_uniq` (`project_id`,`user_id`,`group_id`),
  KEY `sentry_groupbookmark_b6620684` (`project_id`),
  KEY `sentry_groupbookmark_bda51c3c` (`group_id`),
  KEY `sentry_groupbookmark_fbfc09f1` (`user_id`),
  KEY `sentry_groupbookmark_user_id_5eedb134f529cf58` (`user_id`,`group_id`),
  CONSTRAINT `project_id_refs_id_21f533b9c0d3391b` FOREIGN KEY (`project_id`) REFERENCES `sentry_project` (`id`),
  CONSTRAINT `group_id_refs_id_f28e8c4ba0627f4` FOREIGN KEY (`group_id`) REFERENCES `sentry_groupedmessage` (`id`),
  CONSTRAINT `user_id_refs_id_55f268790310e8cd` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_groupbookmark`
--

LOCK TABLES `sentry_groupbookmark` WRITE;
/*!40000 ALTER TABLE `sentry_groupbookmark` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_groupbookmark` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_groupedmessage`
--

DROP TABLE IF EXISTS `sentry_groupedmessage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_groupedmessage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `logger` varchar(64) NOT NULL,
  `level` int(10) unsigned NOT NULL,
  `message` longtext NOT NULL,
  `view` varchar(200),
  `checksum` varchar(32) NOT NULL,
  `status` int(10) unsigned NOT NULL,
  `times_seen` int(10) unsigned NOT NULL,
  `last_seen` datetime NOT NULL,
  `first_seen` datetime NOT NULL,
  `data` longtext,
  `score` int(11) NOT NULL,
  `project_id` int(11),
  `time_spent_total` double NOT NULL,
  `time_spent_count` int(11) NOT NULL,
  `resolved_at` datetime,
  `active_at` datetime,
  `is_public` tinyint(1),
  `platform` varchar(64) DEFAULT NULL,
  `users_seen` int(10) unsigned NOT NULL,
  `num_comments` int(10) unsigned,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sentry_groupedmessage_project_id_31ef19bb52cc13be_uniq` (`project_id`,`checksum`),
  KEY `sentry_groupedmessage_147bb5bf` (`logger`),
  KEY `sentry_groupedmessage_2a8f42e8` (`level`),
  KEY `sentry_groupedmessage_2dbbcad0` (`view`),
  KEY `sentry_groupedmessage_5d699eee` (`checksum`),
  KEY `sentry_groupedmessage_ee4a0d0` (`last_seen`),
  KEY `sentry_groupedmessage_4d23e6a1` (`first_seen`),
  KEY `sentry_groupedmessage_c9ad71dd` (`status`),
  KEY `sentry_groupedmessage_74b0b5cf` (`times_seen`),
  KEY `sentry_groupedmessage_b6620684` (`project_id`),
  KEY `sentry_groupedmessage_942c0e74` (`resolved_at`),
  KEY `sentry_groupedmessage_30fc7d28` (`active_at`),
  KEY `sentry_groupedmessage_project_id_31ef19bb52cc13be` (`project_id`,`checksum`),
  KEY `sentry_groupedmessage_ba2bc1a7` (`users_seen`),
  CONSTRAINT `project_id_refs_id_12bef79feaf653de` FOREIGN KEY (`project_id`) REFERENCES `sentry_project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_groupedmessage`
--

LOCK TABLES `sentry_groupedmessage` WRITE;
/*!40000 ALTER TABLE `sentry_groupedmessage` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_groupedmessage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_groupmeta`
--

DROP TABLE IF EXISTS `sentry_groupmeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_groupmeta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `key` varchar(64) NOT NULL,
  `value` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sentry_groupmeta_key_5d9d7a3c6538b14d_uniq` (`key`,`group_id`),
  KEY `sentry_groupmeta_bda51c3c` (`group_id`),
  CONSTRAINT `group_id_refs_id_608761074f0ebfe5` FOREIGN KEY (`group_id`) REFERENCES `sentry_groupedmessage` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_groupmeta`
--

LOCK TABLES `sentry_groupmeta` WRITE;
/*!40000 ALTER TABLE `sentry_groupmeta` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_groupmeta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_grouptagkey`
--

DROP TABLE IF EXISTS `sentry_grouptagkey`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_grouptagkey` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `group_id` int(11) NOT NULL,
  `key` varchar(32) NOT NULL,
  `values_seen` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sentry_grouptagkey_project_id_7b0c8092f47b509f_uniq` (`project_id`,`group_id`,`key`),
  KEY `sentry_grouptagkey_b6620684` (`project_id`),
  KEY `sentry_grouptagkey_bda51c3c` (`group_id`),
  CONSTRAINT `project_id_refs_id_58a8eb32baf46b2e` FOREIGN KEY (`project_id`) REFERENCES `sentry_project` (`id`),
  CONSTRAINT `group_id_refs_id_b0b6a0d1c3e83ab` FOREIGN KEY (`group_id`) REFERENCES `sentry_groupedmessage` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_grouptagkey`
--

LOCK TABLES `sentry_grouptagkey` WRITE;
/*!40000 ALTER TABLE `sentry_grouptagkey` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_grouptagkey` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_lostpasswordhash`
--

DROP TABLE IF EXISTS `sentry_lostpasswordhash`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_lostpasswordhash` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `hash` varchar(32) NOT NULL,
  `date_added` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `user_id_refs_id_32f8ed48639fbcb2` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_lostpasswordhash`
--

LOCK TABLES `sentry_lostpasswordhash` WRITE;
/*!40000 ALTER TABLE `sentry_lostpasswordhash` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_lostpasswordhash` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_message`
--

DROP TABLE IF EXISTS `sentry_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_message` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `logger` varchar(64) NOT NULL,
  `level` int(10) unsigned NOT NULL,
  `message` longtext NOT NULL,
  `view` varchar(200),
  `server_name` varchar(128),
  `checksum` varchar(32) NOT NULL,
  `datetime` datetime NOT NULL,
  `data` longtext,
  `group_id` int(11),
  `site` varchar(128),
  `message_id` varchar(32),
  `project_id` int(11),
  `time_spent` double,
  `platform` varchar(64) DEFAULT NULL,
  `num_comments` int(10) unsigned,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sentry_message_project_id_b6b4e75e438ca83_uniq` (`project_id`,`message_id`),
  KEY `sentry_message_147bb5bf` (`logger`),
  KEY `sentry_message_2a8f42e8` (`level`),
  KEY `sentry_message_2dbbcad0` (`view`),
  KEY `sentry_message_326e5a6b` (`server_name`),
  KEY `sentry_message_5d699eee` (`checksum`),
  KEY `sentry_message_882a7e0` (`datetime`),
  KEY `sentry_message_bda51c3c` (`group_id`),
  KEY `sentry_message_e00a881a` (`site`),
  KEY `sentry_message_b6620684` (`project_id`),
  CONSTRAINT `group_id_refs_id_2955655b757f499a` FOREIGN KEY (`group_id`) REFERENCES `sentry_groupedmessage` (`id`),
  CONSTRAINT `project_id_refs_id_5206aaca106d0573` FOREIGN KEY (`project_id`) REFERENCES `sentry_project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_message`
--

LOCK TABLES `sentry_message` WRITE;
/*!40000 ALTER TABLE `sentry_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_messagecountbyminute`
--

DROP TABLE IF EXISTS `sentry_messagecountbyminute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_messagecountbyminute` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  `times_seen` int(10) unsigned NOT NULL,
  `project_id` int(11),
  `time_spent_total` double NOT NULL,
  `time_spent_count` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sentry_messagecountbyminute_project_id_32e80903f7cb1505_uniq` (`project_id`,`date`,`group_id`),
  KEY `sentry_messagecountbyminute_bda51c3c` (`group_id`),
  KEY `sentry_messagecountbyminute_b6620684` (`project_id`),
  KEY `sentry_messagecountbyminute_986cbc25` (`date`),
  CONSTRAINT `group_id_refs_id_538495fb557ae099` FOREIGN KEY (`group_id`) REFERENCES `sentry_groupedmessage` (`id`),
  CONSTRAINT `project_id_refs_id_47b6c87b989408e` FOREIGN KEY (`project_id`) REFERENCES `sentry_project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_messagecountbyminute`
--

LOCK TABLES `sentry_messagecountbyminute` WRITE;
/*!40000 ALTER TABLE `sentry_messagecountbyminute` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_messagecountbyminute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_messagefiltervalue`
--

DROP TABLE IF EXISTS `sentry_messagefiltervalue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_messagefiltervalue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `times_seen` int(10) unsigned NOT NULL,
  `key` varchar(32) NOT NULL,
  `value` varchar(200) NOT NULL,
  `project_id` int(11),
  `last_seen` datetime,
  `first_seen` datetime,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sentry_messagefiltervalue_project_id_330bd94e129c0cb7_uniq` (`project_id`,`group_id`,`value`,`key`),
  KEY `sentry_messagefiltervalue_bda51c3c` (`group_id`),
  KEY `sentry_messagefiltervalue_b6620684` (`project_id`),
  KEY `sentry_messagefiltervalue_ee4a0d0` (`last_seen`),
  KEY `sentry_messagefiltervalue_4d23e6a1` (`first_seen`),
  CONSTRAINT `group_id_refs_id_329e3bb8b3571656` FOREIGN KEY (`group_id`) REFERENCES `sentry_groupedmessage` (`id`),
  CONSTRAINT `project_id_refs_id_4dd0aebb850d5883` FOREIGN KEY (`project_id`) REFERENCES `sentry_project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_messagefiltervalue`
--

LOCK TABLES `sentry_messagefiltervalue` WRITE;
/*!40000 ALTER TABLE `sentry_messagefiltervalue` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_messagefiltervalue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_messageindex`
--

DROP TABLE IF EXISTS `sentry_messageindex`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_messageindex` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `object_id` int(10) unsigned NOT NULL,
  `column` varchar(32) NOT NULL,
  `value` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sentry_messageindex_column_23431fca14e385c1_uniq` (`column`,`value`,`object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_messageindex`
--

LOCK TABLES `sentry_messageindex` WRITE;
/*!40000 ALTER TABLE `sentry_messageindex` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_messageindex` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_option`
--

DROP TABLE IF EXISTS `sentry_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_option` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(64) NOT NULL,
  `value` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sentry_option_key_4b34ba95f566b2e7_uniq` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_option`
--

LOCK TABLES `sentry_option` WRITE;
/*!40000 ALTER TABLE `sentry_option` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_option` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_pendingteammember`
--

DROP TABLE IF EXISTS `sentry_pendingteammember`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_pendingteammember` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `team_id` int(11) NOT NULL,
  `email` varchar(75) NOT NULL,
  `type` int(11) NOT NULL,
  `date_added` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sentry_pendingteammember_team_id_5844f21712e0ad85_uniq` (`team_id`,`email`),
  KEY `sentry_pendingteammember_fcf8ac47` (`team_id`),
  CONSTRAINT `team_id_refs_id_265eab8b78b6101` FOREIGN KEY (`team_id`) REFERENCES `sentry_team` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_pendingteammember`
--

LOCK TABLES `sentry_pendingteammember` WRITE;
/*!40000 ALTER TABLE `sentry_pendingteammember` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_pendingteammember` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_project`
--

DROP TABLE IF EXISTS `sentry_project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_project` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `owner_id` int(11),
  `public` tinyint(1) NOT NULL,
  `date_added` datetime NOT NULL,
  `status` int(10) unsigned NOT NULL,
  `slug` varchar(50),
  `team_id` int(11),
  `platform` varchar(32),
  PRIMARY KEY (`id`),
  UNIQUE KEY `sentry_project_slug_7e0cc0d379eb3e42_uniq` (`slug`,`team_id`),
  KEY `sentry_project_5d52dd10` (`owner_id`),
  KEY `sentry_project_c9ad71dd` (`status`),
  KEY `sentry_project_fcf8ac47` (`team_id`),
  CONSTRAINT `owner_id_refs_id_4b3d4eece8585bd5` FOREIGN KEY (`owner_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `team_id_refs_id_72de289ebc4166c6` FOREIGN KEY (`team_id`) REFERENCES `sentry_team` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_project`
--

LOCK TABLES `sentry_project` WRITE;
/*!40000 ALTER TABLE `sentry_project` DISABLE KEYS */;
INSERT INTO `sentry_project` VALUES (1,'Sentry (Internal)',NULL,0,'2013-04-12 14:36:04',0,'sentry',NULL,NULL);
/*!40000 ALTER TABLE `sentry_project` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_projectcountbyminute`
--

DROP TABLE IF EXISTS `sentry_projectcountbyminute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_projectcountbyminute` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `date` datetime NOT NULL,
  `times_seen` int(10) unsigned NOT NULL,
  `time_spent_total` double NOT NULL,
  `time_spent_count` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sentry_projectcountbyminute_project_id_715736d47d350a1d_uniq` (`project_id`,`date`),
  KEY `sentry_projectcountbyminute_b6620684` (`project_id`),
  CONSTRAINT `project_id_refs_id_6cf63e4987de3f4` FOREIGN KEY (`project_id`) REFERENCES `sentry_project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_projectcountbyminute`
--

LOCK TABLES `sentry_projectcountbyminute` WRITE;
/*!40000 ALTER TABLE `sentry_projectcountbyminute` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_projectcountbyminute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_projectkey`
--

DROP TABLE IF EXISTS `sentry_projectkey`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_projectkey` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `public_key` varchar(32) DEFAULT NULL,
  `secret_key` varchar(32) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_added_id` int(11) DEFAULT NULL,
  `date_added` datetime DEFAULT '2013-04-12 14:36:01',
  PRIMARY KEY (`id`),
  UNIQUE KEY `public_key` (`public_key`),
  UNIQUE KEY `secret_key` (`secret_key`),
  KEY `sentry_projectkey_b6620684` (`project_id`),
  KEY `sentry_projectkey_fbfc09f1` (`user_id`),
  KEY `sentry_projectkey_55423318` (`user_added_id`),
  CONSTRAINT `project_id_refs_id_3ecbd5a33b4e7c61` FOREIGN KEY (`project_id`) REFERENCES `sentry_project` (`id`),
  CONSTRAINT `user_id_refs_id_6cff2b2b4e82e587` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `user_added_id_refs_id_6cff2b2b4e82e587` FOREIGN KEY (`user_added_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_projectkey`
--

LOCK TABLES `sentry_projectkey` WRITE;
/*!40000 ALTER TABLE `sentry_projectkey` DISABLE KEYS */;
INSERT INTO `sentry_projectkey` VALUES (1,1,'ee0c9d854b294d20a2d6d92d0191cac8','0baca85229c74e0f95d52bea5418ddfd',NULL,NULL,'2013-04-12 14:36:04');
/*!40000 ALTER TABLE `sentry_projectkey` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_projectoptions`
--

DROP TABLE IF EXISTS `sentry_projectoptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_projectoptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `key` varchar(64) NOT NULL,
  `value` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sentry_projectoptions_project_id_2d0b5c5d84cdbe8f_uniq` (`project_id`,`key`),
  KEY `sentry_projectoptions_b6620684` (`project_id`),
  CONSTRAINT `project_id_refs_id_6f595aafa4c996d6` FOREIGN KEY (`project_id`) REFERENCES `sentry_project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_projectoptions`
--

LOCK TABLES `sentry_projectoptions` WRITE;
/*!40000 ALTER TABLE `sentry_projectoptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_projectoptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_searchdocument`
--

DROP TABLE IF EXISTS `sentry_searchdocument`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_searchdocument` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `total_events` int(10) unsigned NOT NULL,
  `date_added` datetime NOT NULL,
  `date_changed` datetime NOT NULL,
  `status` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sentry_searchdocument_project_id_4f05eb93749c83a8_uniq` (`project_id`,`group_id`),
  KEY `sentry_searchdocument_b6620684` (`project_id`),
  KEY `sentry_searchdocument_bda51c3c` (`group_id`),
  CONSTRAINT `group_id_refs_id_27e4e1f504b5aa2b` FOREIGN KEY (`group_id`) REFERENCES `sentry_groupedmessage` (`id`),
  CONSTRAINT `project_id_refs_id_15790edd8adc6e52` FOREIGN KEY (`project_id`) REFERENCES `sentry_project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_searchdocument`
--

LOCK TABLES `sentry_searchdocument` WRITE;
/*!40000 ALTER TABLE `sentry_searchdocument` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_searchdocument` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_searchtoken`
--

DROP TABLE IF EXISTS `sentry_searchtoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_searchtoken` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `document_id` int(11) NOT NULL,
  `field` varchar(64) NOT NULL,
  `token` varchar(128) NOT NULL,
  `times_seen` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sentry_searchtoken_document_id_18d24748e6f3dee3_uniq` (`document_id`,`field`,`token`),
  KEY `sentry_searchtoken_f4226d13` (`document_id`),
  CONSTRAINT `document_id_refs_id_16a17e423c0ba748` FOREIGN KEY (`document_id`) REFERENCES `sentry_searchdocument` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_searchtoken`
--

LOCK TABLES `sentry_searchtoken` WRITE;
/*!40000 ALTER TABLE `sentry_searchtoken` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_searchtoken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_team`
--

DROP TABLE IF EXISTS `sentry_team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_team` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `slug` varchar(50) NOT NULL,
  `name` varchar(64) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `date_added` datetime,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `sentry_team_5d52dd10` (`owner_id`),
  CONSTRAINT `owner_id_refs_id_3eb2f33ee588e718` FOREIGN KEY (`owner_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_team`
--

LOCK TABLES `sentry_team` WRITE;
/*!40000 ALTER TABLE `sentry_team` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_team` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_teammember`
--

DROP TABLE IF EXISTS `sentry_teammember`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_teammember` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `team_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `type` int(11) NOT NULL,
  `date_added` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sentry_teammember_team_id_66e63508dc6377a0_uniq` (`team_id`,`user_id`),
  KEY `sentry_teammember_fcf8ac47` (`team_id`),
  KEY `sentry_teammember_fbfc09f1` (`user_id`),
  CONSTRAINT `team_id_refs_id_673f9af24cc79471` FOREIGN KEY (`team_id`) REFERENCES `sentry_team` (`id`),
  CONSTRAINT `user_id_refs_id_f4e755183d0e40c` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_teammember`
--

LOCK TABLES `sentry_teammember` WRITE;
/*!40000 ALTER TABLE `sentry_teammember` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_teammember` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_trackeduser`
--

DROP TABLE IF EXISTS `sentry_trackeduser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_trackeduser` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `ident` varchar(200) NOT NULL,
  `email` varchar(75) DEFAULT NULL,
  `data` longtext,
  `last_seen` datetime NOT NULL,
  `first_seen` datetime NOT NULL,
  `num_events` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sentry_trackeduser_project_id_19904d1db6b8c397_uniq` (`project_id`,`ident`),
  KEY `sentry_trackeduser_b6620684` (`project_id`),
  KEY `sentry_trackeduser_ee4a0d0` (`last_seen`),
  KEY `sentry_trackeduser_4d23e6a1` (`first_seen`),
  CONSTRAINT `project_id_refs_id_ab83b04015c6a95` FOREIGN KEY (`project_id`) REFERENCES `sentry_project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_trackeduser`
--

LOCK TABLES `sentry_trackeduser` WRITE;
/*!40000 ALTER TABLE `sentry_trackeduser` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_trackeduser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sentry_useroption`
--

DROP TABLE IF EXISTS `sentry_useroption`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sentry_useroption` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `project_id` int(11) DEFAULT NULL,
  `key` varchar(64) NOT NULL,
  `value` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sentry_useroption_user_id_4d4ce0b1f7bb578b_uniq` (`user_id`,`project_id`,`key`),
  KEY `sentry_useroption_fbfc09f1` (`user_id`),
  KEY `sentry_useroption_b6620684` (`project_id`),
  CONSTRAINT `user_id_refs_id_d04f03fc3002f4d` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `project_id_refs_id_787738bcb9806ecb` FOREIGN KEY (`project_id`) REFERENCES `sentry_project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sentry_useroption`
--

LOCK TABLES `sentry_useroption` WRITE;
/*!40000 ALTER TABLE `sentry_useroption` DISABLE KEYS */;
/*!40000 ALTER TABLE `sentry_useroption` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `social_auth_association`
--

DROP TABLE IF EXISTS `social_auth_association`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `social_auth_association` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `server_url` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `secret` varchar(255) NOT NULL,
  `issued` int(11) NOT NULL,
  `lifetime` int(11) NOT NULL,
  `assoc_type` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `social_auth_association_handle_693a924207fa6ae_uniq` (`handle`,`server_url`),
  KEY `social_auth_association_5a32b972` (`issued`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `social_auth_association`
--

LOCK TABLES `social_auth_association` WRITE;
/*!40000 ALTER TABLE `social_auth_association` DISABLE KEYS */;
/*!40000 ALTER TABLE `social_auth_association` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `social_auth_nonce`
--

DROP TABLE IF EXISTS `social_auth_nonce`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `social_auth_nonce` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `server_url` varchar(255) NOT NULL,
  `timestamp` int(11) NOT NULL,
  `salt` varchar(40) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `social_auth_nonce_timestamp_3833ba21ef52524a_uniq` (`timestamp`,`salt`,`server_url`),
  KEY `social_auth_nonce_67f1b7ce` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `social_auth_nonce`
--

LOCK TABLES `social_auth_nonce` WRITE;
/*!40000 ALTER TABLE `social_auth_nonce` DISABLE KEYS */;
/*!40000 ALTER TABLE `social_auth_nonce` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `social_auth_usersocialauth`
--

DROP TABLE IF EXISTS `social_auth_usersocialauth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `social_auth_usersocialauth` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `provider` varchar(32) NOT NULL,
  `uid` varchar(255) NOT NULL,
  `extra_data` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `social_auth_usersocialauth_provider_2f763109e2c4a1fb_uniq` (`provider`,`uid`),
  KEY `social_auth_usersocialauth_fbfc09f1` (`user_id`),
  CONSTRAINT `user_id_refs_id_529c317860fa311b` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `social_auth_usersocialauth`
--

LOCK TABLES `social_auth_usersocialauth` WRITE;
/*!40000 ALTER TABLE `social_auth_usersocialauth` DISABLE KEYS */;
/*!40000 ALTER TABLE `social_auth_usersocialauth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `south_migrationhistory`
--

DROP TABLE IF EXISTS `south_migrationhistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `south_migrationhistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_name` varchar(255) NOT NULL,
  `migration` varchar(255) NOT NULL,
  `applied` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `south_migrationhistory`
--

LOCK TABLES `south_migrationhistory` WRITE;
/*!40000 ALTER TABLE `south_migrationhistory` DISABLE KEYS */;
INSERT INTO `south_migrationhistory` VALUES (1,'djcelery','0001_initial','2013-04-12 14:35:55'),(2,'djcelery','0002_v25_changes','2013-04-12 14:35:55'),(3,'djcelery','0003_v26_changes','2013-04-12 14:35:55'),(4,'djcelery','0004_v30_changes','2013-04-12 14:35:55'),(5,'django','0001_initial','2013-04-12 14:35:55'),(6,'sentry','0001_initial','2013-04-12 14:35:56'),(7,'sentry','0002_auto__del_field_groupedmessage_url__chg_field_groupedmessage_view__chg','2013-04-12 14:35:56'),(8,'sentry','0003_auto__add_field_message_group__del_field_groupedmessage_server_name','2013-04-12 14:35:56'),(9,'sentry','0004_auto__add_filtervalue__add_unique_filtervalue_key_value','2013-04-12 14:35:56'),(10,'sentry','0005_auto','2013-04-12 14:35:56'),(11,'sentry','0006_auto','2013-04-12 14:35:56'),(12,'sentry','0007_auto__add_field_message_site','2013-04-12 14:35:56'),(13,'sentry','0008_auto__chg_field_message_view__add_field_groupedmessage_data__chg_field','2013-04-12 14:35:56'),(14,'sentry','0009_auto__add_field_message_message_id','2013-04-12 14:35:56'),(15,'sentry','0010_auto__add_messageindex__add_unique_messageindex_column_value_object_id','2013-04-12 14:35:56'),(16,'sentry','0011_auto__add_field_groupedmessage_score','2013-04-12 14:35:56'),(17,'sentry','0012_auto','2013-04-12 14:35:56'),(18,'sentry','0013_auto__add_messagecountbyminute__add_unique_messagecountbyminute_group_','2013-04-12 14:35:56'),(19,'sentry','0014_auto','2013-04-12 14:35:56'),(20,'sentry','0014_auto__add_project__add_projectmember__add_unique_projectmember_project','2013-04-12 14:35:57'),(21,'sentry','0015_auto__add_field_message_project__add_field_messagecountbyminute_projec','2013-04-12 14:35:57'),(22,'sentry','0016_auto__add_field_projectmember_is_superuser','2013-04-12 14:35:57'),(23,'sentry','0017_auto__add_field_projectmember_api_key','2013-04-12 14:35:57'),(24,'sentry','0018_auto__chg_field_project_owner','2013-04-12 14:35:57'),(25,'sentry','0019_auto__del_field_projectmember_api_key__add_field_projectmember_public_','2013-04-12 14:35:57'),(26,'sentry','0020_auto__add_projectdomain__add_unique_projectdomain_project_domain','2013-04-12 14:35:57'),(27,'sentry','0021_auto__del_message__del_groupedmessage__del_unique_groupedmessage_proje','2013-04-12 14:35:57'),(28,'sentry','0022_auto__del_field_group_class_name__del_field_group_traceback__del_field','2013-04-12 14:35:57'),(29,'sentry','0023_auto__add_field_event_time_spent','2013-04-12 14:35:57'),(30,'sentry','0024_auto__add_field_group_time_spent_total__add_field_group_time_spent_cou','2013-04-12 14:35:57'),(31,'sentry','0025_auto__add_field_messagecountbyminute_time_spent_total__add_field_messa','2013-04-12 14:35:58'),(32,'sentry','0026_auto__add_field_project_status','2013-04-12 14:35:58'),(33,'sentry','0027_auto__chg_field_event_server_name','2013-04-12 14:35:58'),(34,'sentry','0028_auto__add_projectoptions__add_unique_projectoptions_project_key_value','2013-04-12 14:35:58'),(35,'sentry','0029_auto__del_field_projectmember_is_superuser__del_field_projectmember_pe','2013-04-12 14:35:58'),(36,'sentry','0030_auto__add_view__chg_field_event_group','2013-04-12 14:35:58'),(37,'sentry','0031_auto__add_field_view_verbose_name__add_field_view_verbose_name_plural_','2013-04-12 14:35:58'),(38,'sentry','0032_auto__add_eventmeta','2013-04-12 14:35:58'),(39,'sentry','0033_auto__add_option__add_unique_option_key_value','2013-04-12 14:35:58'),(40,'sentry','0034_auto__add_groupbookmark__add_unique_groupbookmark_project_user_group','2013-04-12 14:35:58'),(41,'sentry','0034_auto__add_unique_option_key__del_unique_option_value_key__del_unique_g','2013-04-12 14:35:58'),(42,'sentry','0036_auto__chg_field_option_value__chg_field_projectoption_value','2013-04-12 14:35:58'),(43,'sentry','0037_auto__add_unique_option_key__del_unique_option_value_key__del_unique_g','2013-04-12 14:35:59'),(44,'sentry','0038_auto__add_searchtoken__add_unique_searchtoken_document_field_token__ad','2013-04-12 14:35:59'),(45,'sentry','0039_auto__add_field_searchdocument_status','2013-04-12 14:35:59'),(46,'sentry','0040_auto__del_unique_event_event_id__add_unique_event_project_event_id','2013-04-12 14:35:59'),(47,'sentry','0041_auto__add_field_messagefiltervalue_last_seen__add_field_messagefilterv','2013-04-12 14:35:59'),(48,'sentry','0042_auto__add_projectcountbyminute__add_unique_projectcountbyminute_projec','2013-04-12 14:35:59'),(49,'sentry','0043_auto__chg_field_option_value__chg_field_projectoption_value','2013-04-12 14:35:59'),(50,'sentry','0044_auto__add_field_projectmember_is_active','2013-04-12 14:35:59'),(51,'sentry','0045_auto__add_pendingprojectmember__add_unique_pendingprojectmember_projec','2013-04-12 14:35:59'),(52,'sentry','0046_auto__add_teammember__add_unique_teammember_team_user__add_team__add_p','2013-04-12 14:36:00'),(53,'sentry','0047_migrate_project_slugs','2013-04-12 14:36:00'),(54,'sentry','0048_migrate_project_keys','2013-04-12 14:36:00'),(55,'sentry','0049_create_default_project_keys','2013-04-12 14:36:00'),(56,'sentry','0050_remove_project_keys_from_members','2013-04-12 14:36:00'),(57,'sentry','0051_auto__del_pendingprojectmember__del_unique_pendingprojectmember_projec','2013-04-12 14:36:00'),(58,'sentry','0052_migrate_project_members','2013-04-12 14:36:00'),(59,'sentry','0053_auto__del_projectmember__del_unique_projectmember_project_user','2013-04-12 14:36:00'),(60,'sentry','0054_fix_project_keys','2013-04-12 14:36:00'),(61,'sentry','0055_auto__del_projectdomain__del_unique_projectdomain_project_domain','2013-04-12 14:36:00'),(62,'sentry','0056_auto__add_field_group_resolved_at','2013-04-12 14:36:00'),(63,'sentry','0057_auto__add_field_group_active_at','2013-04-12 14:36:01'),(64,'sentry','0058_auto__add_useroption__add_unique_useroption_user_project_key','2013-04-12 14:36:01'),(65,'sentry','0059_auto__add_filterkey__add_unique_filterkey_project_key','2013-04-12 14:36:01'),(66,'sentry','0060_fill_filter_key','2013-04-12 14:36:01'),(67,'sentry','0061_auto__add_field_group_group_id__add_field_group_is_public','2013-04-12 14:36:01'),(68,'sentry','0062_correct_del_index_sentry_groupedmessage_logger__view__checksum','2013-04-12 14:36:01'),(69,'sentry','0063_auto','2013-04-12 14:36:01'),(70,'sentry','0064_index_checksum','2013-04-12 14:36:01'),(71,'sentry','0065_create_default_project_key','2013-04-12 14:36:01'),(72,'sentry','0066_auto__del_view','2013-04-12 14:36:01'),(73,'sentry','0067_auto__add_field_group_platform__add_field_event_platform','2013-04-12 14:36:01'),(74,'sentry','0068_auto__add_field_projectkey_user_added__add_field_projectkey_date_added','2013-04-12 14:36:01'),(75,'sentry','0069_auto__add_lostpasswordhash','2013-04-12 14:36:02'),(76,'sentry','0070_projectoption_key_length','2013-04-12 14:36:02'),(77,'sentry','0071_auto__add_field_group_users_seen','2013-04-12 14:36:02'),(78,'sentry','0072_auto__add_affecteduserbygroup__add_unique_affecteduserbygroup_project_','2013-04-12 14:36:02'),(79,'sentry','0073_auto__add_field_project_platform','2013-04-12 14:36:02'),(80,'sentry','0074_correct_filtervalue_index','2013-04-12 14:36:02'),(81,'sentry','0075_add_groupbookmark_index','2013-04-12 14:36:02'),(82,'sentry','0076_add_groupmeta_index','2013-04-12 14:36:02'),(83,'sentry','0077_auto__add_trackeduser__add_unique_trackeduser_project_ident','2013-04-12 14:36:02'),(84,'sentry','0078_auto__add_field_affecteduserbygroup_tuser','2013-04-12 14:36:02'),(85,'sentry','0079_auto__del_unique_affecteduserbygroup_project_ident_group__add_unique_a','2013-04-12 14:36:03'),(86,'sentry','0080_auto__chg_field_affecteduserbygroup_ident','2013-04-12 14:36:03'),(87,'sentry','0081_fill_trackeduser','2013-04-12 14:36:03'),(88,'sentry','0082_auto__add_activity__add_field_group_num_comments__add_field_event_num_','2013-04-12 14:36:03'),(89,'sentry','0083_migrate_dupe_groups','2013-04-12 14:36:03'),(90,'sentry','0084_auto__del_unique_group_project_checksum_logger_culprit__add_unique_gro','2013-04-12 14:36:03'),(91,'sentry','0085_auto__del_unique_project_slug__add_unique_project_slug_team','2013-04-12 14:36:03'),(92,'sentry','0086_auto__add_field_team_date_added','2013-04-12 14:36:03'),(93,'sentry','0087_auto__del_messagefiltervalue__del_unique_messagefiltervalue_project_ke','2013-04-12 14:36:03'),(94,'sentry','0088_auto__del_messagecountbyminute__del_unique_messagecountbyminute_projec','2013-04-12 14:36:04'),(95,'sentry','0089_auto__add_accessgroup__add_unique_accessgroup_team_name','2013-04-12 14:36:04'),(96,'sentry','0090_auto__add_grouptagkey__add_unique_grouptagkey_project_group_key__add_f','2013-04-12 14:36:04'),(97,'sentry','0091_auto__add_alert','2013-04-12 14:36:04'),(98,'sentry','0092_auto__add_alertrelatedgroup__add_unique_alertrelatedgroup_group_alert','2013-04-12 14:36:04'),(99,'social_auth','0001_initial','2013-04-12 14:36:05'),(100,'social_auth','0002_auto__add_unique_nonce_timestamp_salt_server_url__add_unique_associati','2013-04-12 14:36:05');
/*!40000 ALTER TABLE `south_migrationhistory` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-04-16 16:05:10
