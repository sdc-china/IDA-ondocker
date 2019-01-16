DROP TABLE IF EXISTS `test_step`;
DROP TABLE IF EXISTS `snapshot_step`;
DROP TABLE IF EXISTS `checkstyle_step`;
DROP TABLE IF EXISTS `deployment_step`;
DROP TABLE IF EXISTS `script_step`;
DROP TABLE IF EXISTS `pipeline_step`;

DROP TABLE IF EXISTS `test_build_step`;
DROP TABLE IF EXISTS `snapshot_build_step`;
DROP TABLE IF EXISTS `checkstyle_build_step`;
DROP TABLE IF EXISTS `deployment_build_step`;
DROP TABLE IF EXISTS `script_build_step`;
DROP TABLE IF EXISTS `build_step`;
DROP TABLE IF EXISTS `build_stage`;
DROP TABLE IF EXISTS `build`;

DROP TABLE IF EXISTS `stage`;
DROP TABLE IF EXISTS `pipeline`;

DROP TABLE IF EXISTS `test_step_info`;
DROP TABLE IF EXISTS `human_task_data`;
DROP TABLE IF EXISTS `service_data`;
DROP TABLE IF EXISTS `rest_api_data`;
DROP TABLE IF EXISTS `process_instance_data`;
DROP TABLE IF EXISTS `test_case_info`;
DROP TABLE IF EXISTS `test_suite_info`;
DROP TABLE IF EXISTS `test_result`;
DROP TABLE IF EXISTS `svg`;
DROP TABLE IF EXISTS `artifact_data`;
DROP TABLE IF EXISTS `command_parameter`;
DROP TABLE IF EXISTS `custom_command`;
DROP TABLE IF EXISTS `case_step`;
DROP TABLE IF EXISTS `command`;
DROP TABLE IF EXISTS `category`;
DROP TABLE IF EXISTS `bpm_user`;
DROP TABLE IF EXISTS `project_collaborators`;
DROP TABLE IF EXISTS `project_bpm_configs`;
DROP TABLE IF EXISTS `bpm_config`;
DROP TABLE IF EXISTS `test_case`;
DROP TABLE IF EXISTS `test_suite`;
DROP TABLE IF EXISTS `project`;

DROP TABLE IF EXISTS `monitor`;
DROP TABLE IF EXISTS `component_entity`;
DROP TABLE IF EXISTS `bpm_event`;
DROP TABLE IF EXISTS `external_test_data`;
DROP TABLE IF EXISTS `testing_configuration_multiple_selenium_gird_config`;

DROP TABLE IF EXISTS `testing_configuration`;
DROP TABLE IF EXISTS `selenium_grid_config`;
DROP TABLE IF EXISTS `custom_recorder`;
DROP TABLE IF EXISTS `user`;
DROP TABLE IF EXISTS `organization`;
--
-- Table structure for table `organization`
--


CREATE TABLE `organization` (
  `id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `active` bit(1) NOT NULL,
  `company_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `user`
--


CREATE TABLE `user` (
  `id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `active` bit(1) NOT NULL,
  `password` varchar(50) NOT NULL,
  `role` varchar(50) NOT NULL,
  `user_name` varchar(50) NOT NULL,
  `email` varchar(100),
  `token` varchar(255),
  `organization_id` bigint(20) NOT NULL,
  CONSTRAINT `USER_ORGANIZATION_FK` FOREIGN KEY (`organization_id`) REFERENCES `organization` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `custom_recorder`
--


CREATE TABLE `custom_recorder` (
  `id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `script` text,
  `organization_id` bigint(20) NOT NULL,
  CONSTRAINT `CUSTOM_RECORDER_ORGANIZATION_FK` FOREIGN KEY (`organization_id`) REFERENCES `organization` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `selenium_grid_config`
--


CREATE TABLE `selenium_grid_config` (
  `id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `browser` varchar(50) NOT NULL,
  `node_number` int(11) NOT NULL,
  `selenium_grid_server_name` varchar(50) NOT NULL,
  `selenium_grid_url` varchar(100) NOT NULL,
  `organization_id` bigint(20) NOT NULL,
  CONSTRAINT `SELENUIM_GRID_CONFIG_UNIQUE` UNIQUE (`selenium_grid_url`, `browser`),
  CONSTRAINT `SELENUIM_GRID_CONFIG_ORGANIZATION_FK` FOREIGN KEY (`organization_id`) REFERENCES `organization` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `testing_configuration`
--

CREATE TABLE `testing_configuration` (
  `id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `selenium_gird_config_id` bigint(20) DEFAULT NULL,
  CONSTRAINT `TESTING_CONFIG_SELENUIM_GRID_CONFIG_FK` FOREIGN KEY (`selenium_gird_config_id`) REFERENCES `selenium_grid_config` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `project`
--


CREATE TABLE `project` (
  `id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `active` bit(1) NOT NULL,
  `description` text,
  `name` varchar(100) NOT NULL,
  `process_app_data_xml` longtext,
  `owner_id` bigint(20) NOT NULL,
  `testing_config_id` bigint(20) DEFAULT NULL,
  CONSTRAINT `PROJECT_TESTING_CONFIG_FK` FOREIGN KEY (`testing_config_id`) REFERENCES `testing_configuration` (`id`),
  CONSTRAINT `PROJECT_OWNER_FK` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `test_suite`
--


CREATE TABLE `test_suite` (
  `id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `test_suit_name` varchar(100) NOT NULL,
  `test_suit_type` varchar(100) NOT NULL,
  `project_id` bigint(20) DEFAULT NULL,
  CONSTRAINT `TEST_SUITE_PROJECT_FK` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `external_test_data`
--

CREATE TABLE `external_test_data` (
	`id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`file_content` mediumtext,
	`file_name` varchar(100) not null,
	`file_type` varchar(255),
	`project_id` bigint(20)	
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `test_case`
--


CREATE TABLE `test_case` (
  `id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `case_name` varchar(100) NOT NULL,
  `case_description` text,
  `creation_date` datetime DEFAULT NULL,
  `exec_status` varchar(10) DEFAULT NULL,
  `case_flow` text,
  `process_name` varchar(100) DEFAULT NULL,
  `process_type` varchar(30) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `creator_id` bigint(20) NOT NULL,
  `project_id` bigint(20) NOT NULL,
  `test_suite_id` bigint(20) NOT NULL,
  `updater_id` bigint(20) DEFAULT NULL,
  `editor_id` bigint(20) DEFAULT NULL,  
  `executor_id` bigint(20) DEFAULT NULL,
  `external_test_data_id` bigint(20) DEFAULT NULL,
  CONSTRAINT `TESTCASE_UPDATER_FK` FOREIGN KEY (`updater_id`) REFERENCES `user` (`id`),
  CONSTRAINT `TESTCASE_TESTSUITE_FK` FOREIGN KEY (`test_suite_id`) REFERENCES `test_suite` (`id`),
  CONSTRAINT `TESTCASE_PROJECT_FK` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`),
  CONSTRAINT `TESTCASE_CREATOR_FK` FOREIGN KEY (`creator_id`) REFERENCES `user` (`id`),
  CONSTRAINT `TESTCASE_EDITOR_FK` FOREIGN KEY (`editor_id`) REFERENCES `user` (`id`),
  CONSTRAINT `TESTCASE_EXECUTOR_FK` FOREIGN KEY (`executor_id`) REFERENCES `user` (`id`),
  CONSTRAINT `TESTCASE_TESTDATA_FK` FOREIGN KEY (`external_test_data_id`) REFERENCES `external_test_data` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `bpm_config`
--


CREATE TABLE `bpm_config` (
  `id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `bpm_version` varchar(30) NOT NULL,
  `bpm_config_name` varchar(255) NOT NULL,
  `connected_server_name` varchar(50) DEFAULT NULL,
  `rest_uri` varchar(50) NOT NULL,
  `rest_service_user_name` varchar(100) NOT NULL,
  `rest_service_user_password` varchar(255) NOT NULL,
  `server_host` varchar(100) DEFAULT NULL,
  `server_url` varchar(255) NOT NULL,
  `soap_port` varchar(30) DEFAULT NULL,
  `server_type` varchar(20) NOT NULL,
  `was_admin_user_name` varchar(100) DEFAULT NULL,
  `was_admin_user_password` varchar(255) DEFAULT NULL,
  `ssh_user` varchar(100) DEFAULT NULL,
  `ssh_key` text DEFAULT NULL,
  `was_admin_command` varchar(1024) DEFAULT NULL,
  `systemId` varchar(64) ,
  `organization_id` bigint(20) NOT NULL,
  CONSTRAINT `BPM_CONFIG_ORGANIZATION_FK` FOREIGN KEY (`organization_id`) REFERENCES `organization` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `project_bpm_configs`
--


CREATE TABLE `project_bpm_configs` (
  `project_id` bigint(20) NOT NULL,
  `bpm_configs_id` bigint(20) NOT NULL,
  CONSTRAINT `PROJECT_BPM_CONFIG_FK` FOREIGN KEY (`bpm_configs_id`) REFERENCES `bpm_config` (`id`),
  CONSTRAINT `BPM_CONFIG_PROJECT_FK` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `project_collaborators`
--


CREATE TABLE `project_collaborators` (
  `project_id` bigint(20) NOT NULL,
  `collaborators_id` bigint(20) NOT NULL,
  CONSTRAINT `PROJECT_COLLABORATORS_FK` FOREIGN KEY (`collaborators_id`) REFERENCES `user` (`id`),
  CONSTRAINT `COLLABORATORS_PROJECT_FK` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `bpm_user`
--


CREATE TABLE `bpm_user` (
  `id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `bpm_display_name` varchar(255) NOT NULL,
  `bpm_role` varchar(255) DEFAULT NULL,
  `bpm_user_name` varchar(100) NOT NULL,
  `bpm_user_password` varchar(255) NOT NULL,
  `bpm_configuration_id` bigint(20) DEFAULT NULL,
  `selenium_grid_configuration_id` bigint(20) DEFAULT NULL,
  CONSTRAINT `BPM_USER_UNIQUE` UNIQUE (`bpm_user_name`, `bpm_configuration_id`),
  CONSTRAINT `BPM_USER_BPM_CONFIGURATION_FK` FOREIGN KEY (`bpm_configuration_id`) REFERENCES `bpm_config` (`id`),
  CONSTRAINT `BPM_USER_SELENIUM_GRID_CONFIGURATION_FK` FOREIGN KEY (`selenium_grid_configuration_id`) REFERENCES `selenium_grid_config` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `category`
--


CREATE TABLE `category` (
  `id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `category_type` varchar(20) NOT NULL,
  `creation_date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `name` varchar(30) UNIQUE NOT NULL,
  `sort` int(11) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `parent` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `command`
--


CREATE TABLE `command` (
  `id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `creation_date` datetime DEFAULT NULL,
  `description` varchar(1024) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `update_date` datetime DEFAULT NULL,
  `verbalization` varchar(255) DEFAULT NULL,
  `category_id` bigint(20) DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `project_id` bigint(20) DEFAULT NULL,
  `takescreenshot` boolean NOT NULL,
  `execution_type` varchar(20) DEFAULT NULL,
  `scope` varchar(64) DEFAULT NULL,
  `script` text DEFAULT NULL,
  CONSTRAINT `COMMAND_UNIQUE` UNIQUE (`name`, `category_id`, `project_id`),
  CONSTRAINT `COMMAND_PROJECT_FK` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`),
  CONSTRAINT `COMMAND_CATEGROY_FK` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`),
  CONSTRAINT `COMMAND_CREATOR_FK` FOREIGN KEY (`creator_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `case_step`
--

CREATE TABLE `case_step` (
  `id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `case_data` text,
  `comment` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `exception_trace` text,
  `exec_status` varchar(10) DEFAULT NULL,
  `case_step_index` int(11) DEFAULT NULL,
  `parameters` text,
  `screenshot_path` varchar(255) DEFAULT NULL,
  `script` text,
  `test_result` mediumtext,
  `bpm_user_id` bigint(20) DEFAULT NULL,
  `command_id` bigint(20) DEFAULT NULL,
  `group_command_id` bigint(20) DEFAULT NULL,
  `test_case_id` bigint(20) DEFAULT NULL,
  CONSTRAINT `CASE_STEP_TEST_CASE_FK` FOREIGN KEY (`test_case_id`) REFERENCES `test_case` (`id`),
  CONSTRAINT `CASE_STEP_GROUP_COMMAND_FK` FOREIGN KEY (`group_command_id`) REFERENCES `command` (`id`),
  CONSTRAINT `CASE_STEP_COMMAND_FK` FOREIGN KEY (`command_id`) REFERENCES `command` (`id`),
  CONSTRAINT `CASE_STEP_BPM_USER_FK` FOREIGN KEY (`bpm_user_id`) REFERENCES `bpm_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `parameter`
--


CREATE TABLE `command_parameter` (
  `id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `checked` varchar(30) DEFAULT NULL,
  `creation_date` datetime DEFAULT NULL,
  `display_name` varchar(255) NOT NULL,
  `hidden` varchar(30) DEFAULT NULL,
  `parameter_name` varchar(100) NOT NULL,
  `param_regexp` varchar(255) DEFAULT NULL,
  `param_source` varchar(255) DEFAULT NULL,
  `parameter_type` varchar(30) NOT NULL,
  `unchecked` varchar(30) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `command_id` bigint(20) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  CONSTRAINT `PARAMETER_UNIQUE` UNIQUE (`parameter_name`, `command_id`),
  CONSTRAINT `PARAMETER_COMMAND_FK` FOREIGN KEY (`command_id`) REFERENCES `command` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `test_result`
--


CREATE TABLE `test_result` (
  `id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `build_id` bigint(20) DEFAULT NULL,
  `duration` varchar(10) DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `environment` varchar(50) DEFAULT NULL,
  `exec_status` varchar(10) DEFAULT NULL,
  `fail_number` int(11) DEFAULT NULL,
  `folder` varchar(255) DEFAULT NULL,
  `logs_path` varchar(255) DEFAULT NULL,
  `process_app_name` varchar(100) DEFAULT NULL,
  `project_id` bigint(20) DEFAULT NULL,
  `server_url` varchar(100) DEFAULT NULL,
  `snapshot_name` varchar(100) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `success_number` int(11) DEFAULT NULL,
  `success_rate` varchar(10) DEFAULT NULL,
  `total` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `test_suite_info`
--


CREATE TABLE `test_suite_info` (
  `id` bigint(20) NOT NULL PRIMARY KEY  AUTO_INCREMENT,
  `duration` varchar(10) DEFAULT NULL,
  `exec_status` varchar(10) DEFAULT NULL,
  `fail_number` int(11) DEFAULT NULL,
  `suite_name` varchar(100) DEFAULT NULL,
  `success_number` int(11) DEFAULT NULL,
  `success_rate` varchar(10) DEFAULT NULL,
  `total` int(11) DEFAULT NULL,
  `test_result_id` bigint(20) DEFAULT NULL, 
  CONSTRAINT `TEST_SUITE_INFO_TEST_RESULT_FK` FOREIGN KEY (`test_result_id`) REFERENCES `test_result` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `test_case_info`
--


CREATE TABLE `test_case_info` (
  `id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `case_type` varchar(20) DEFAULT NULL,
  `duration` varchar(10) DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `exec_status` varchar(10) DEFAULT NULL,
  `case_name` varchar(100) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `browser` varchar(100) DEFAULT NULL,
  `test_suite_info_id` bigint(20) DEFAULT NULL,
  `test_case_id` bigint(20) DEFAULT NULL,
   CONSTRAINT `TEST_CASE_INFO_TEST_CASE_FK` FOREIGN KEY (`test_case_id`) REFERENCES `test_case` (`id`),
   CONSTRAINT `TEST_CASE_INFO_TEST_SUITE_INFO_FK` FOREIGN KEY (`test_suite_info_id`) REFERENCES `test_suite_info` (`id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `test_step_info`
--


CREATE TABLE `test_step_info` (
  `id` bigint(20) NOT NULL PRIMARY KEY  AUTO_INCREMENT,
  `category` varchar(30) DEFAULT NULL,
  `command` varchar(100) DEFAULT NULL,
  `description` text,
  `exception_trace` text,
  `exec_status` varchar(10) DEFAULT NULL,
  `test_step_name` varchar(100) DEFAULT NULL,
  `test_step_id` bigint(20) DEFAULT NULL,
  `test_step_index` int(11) DEFAULT NULL,
  `test_step_parent` bigint(20) DEFAULT NULL,
  `parameters` text,
  `screenshot_path` varchar(255) DEFAULT NULL,
  `test_case_info_id` bigint(20) DEFAULT NULL,
  `full_index` varchar(30) DEFAULT NULL,
  `parent_index` varchar(30) DEFAULT NULL,
  `is_group_command_step` boolean,
  CONSTRAINT `TEST_STEP_INFO_TEST_CASE_INFO_FK` FOREIGN KEY (`test_case_info_id`) REFERENCES `test_case_info` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `artifact_data`
--

CREATE TABLE `artifact_data` (
  `id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `artifact_id` varchar(50) DEFAULT NULL,
  `artifact_data` mediumtext,
  `artifact_type` varchar(20) NOT NULL,
  `duration` varchar(30) DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `error` text,
  `data_name` varchar(255) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `svg`
--


CREATE TABLE `svg` (
  `id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `content` mediumtext,
  `svg_name` varchar(255) DEFAULT NULL,
  `svg_type` varchar(50) DEFAULT NULL,
  `artifact_data_id` bigint(20) DEFAULT NULL,
  CONSTRAINT `SVG_ARTIFACT_DATA_ID` FOREIGN KEY (`artifact_data_id`) REFERENCES `artifact_data` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `process_instance_data`
--

CREATE TABLE `process_instance_data` (
  `id` bigint(20) PRIMARY KEY  NOT NULL,
  `test_case_info_id` bigint(20) DEFAULT NULL,
  CONSTRAINT `PROCESS_INSTANCE_DATA_ARTIFACT_DATA_FK` FOREIGN KEY (`id`) REFERENCES `artifact_data` (`id`),
  CONSTRAINT `PROCESS_INSTANCE_DATA_TEST_CASE_INFO_FK` FOREIGN KEY (`test_case_info_id`) REFERENCES `test_case_info` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `human_task_data`
--


CREATE TABLE `human_task_data` (
  `id` bigint(20) NOT NULL PRIMARY KEY  AUTO_INCREMENT,
  `human_task_data` text,
  `duration` varchar(30) DEFAULT NULL,
  `task_name` varchar(255) DEFAULT NULL,
  `task_type` varchar(50) DEFAULT NULL,
  `process_instance_data_id` bigint(20) DEFAULT NULL,
  CONSTRAINT `HUMAN_TASK_DATA_PROCESS_INSTANCE_DATA_FK` FOREIGN KEY (`process_instance_data_id`) REFERENCES `process_instance_data` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `rest_api_data`
--


CREATE TABLE `rest_api_data` (
  `id` bigint(20) PRIMARY KEY NOT NULL,
  `test_case_info_id` bigint(20) DEFAULT NULL,
  CONSTRAINT `REST_API_DATA_ARTIFACT_DATA_FK` FOREIGN KEY (`id`) REFERENCES `artifact_data` (`id`),
  CONSTRAINT `REST_API_DATA_TEST_CASE_INFO_FK` FOREIGN KEY (`test_case_info_id`) REFERENCES `test_case_info` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `service_data`
--


CREATE TABLE `service_data` (
  `id` bigint(20) PRIMARY KEY NOT NULL,
  `test_case_info_id` bigint(20) DEFAULT NULL,
  CONSTRAINT `SERVICE_DATA_ARTIFACT_DATA_FK` FOREIGN KEY (`id`) REFERENCES `artifact_data` (`id`),
  CONSTRAINT `SERVICE_DATA_TEST_CASE_INFO_FK` FOREIGN KEY (`test_case_info_id`) REFERENCES `test_case_info` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;





CREATE TABLE `pipeline` (
  `id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `active` bit(1) NOT NULL,
  `creation_date` datetime DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `recipients` varchar(255) DEFAULT NULL,
  `schedule_time` varchar(10) DEFAULT NULL,
  `schedule_type` varchar(30) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `creator_id` bigint(20) NOT NULL,
  `email_type` varchar(10) DEFAULT NULL,
  `email_script` mediumtext DEFAULT NULL,
  CONSTRAINT `PIPELINE_USER_FK` FOREIGN KEY (`creator_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `stage` (
  `id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `stage_type` varchar(10) NOT NULL,
  `stage_index` int(11) DEFAULT NULL,
  `branch_id` varchar(50) DEFAULT NULL,
  `process_app_id` varchar(50) DEFAULT NULL,
  `snapshot_id` varchar(50) DEFAULT NULL,
  `bpm_configuration_id` bigint(20) DEFAULT NULL,
  `pipeline_id` bigint(20) NOT NULL,
  CONSTRAINT `STG_PIPELINE_FK` FOREIGN KEY (`pipeline_id`) REFERENCES `pipeline` (`id`),
  CONSTRAINT `STG_BPMSERVER_FK` FOREIGN KEY (`bpm_configuration_id`) REFERENCES `bpm_config` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `pipeline_step` (
  `id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `active` bit(1) NOT NULL,
  `step_type` varchar(20) NOT NULL,
  `pipeline_step_index` int(11) DEFAULT NULL,
  `stage_id` bigint(20) DEFAULT NULL,
  CONSTRAINT `STEP_STG_FK` FOREIGN KEY (`stage_id`) REFERENCES `stage` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `test_step` (
  `id` bigint(20) NOT NULL PRIMARY KEY,
  `is_tip` bit(1) DEFAULT NULL,
  `project_id` bigint(20) DEFAULT NULL,
  `selected_test_case_ids` varchar(1024) DEFAULT NULL,
  CONSTRAINT `TEST_STEP_FK` FOREIGN KEY (`id`) REFERENCES `pipeline_step` (`id`),
  CONSTRAINT `TEST_STEP_PROJECT_FK` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `snapshot_step` (
  `naming_convention` varchar(100) NOT NULL,
  `id` bigint(20) NOT NULL PRIMARY KEY,
  CONSTRAINT `SNAPSHOT_STEP_FK` FOREIGN KEY (`id`) REFERENCES `pipeline_step` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `checkstyle_step` (
  `ignore_doc_check` boolean NOT NULL,
  `ignore_js_check` boolean NOT NULL,
  `halt_on_failure` boolean NOT NULL,
  `health_score_threshold` bigint(20) NOT NULL default 20,
  `warnings_threshold` bigint(20) NOT NULL default 200,
  `is_tip` bit(1) DEFAULT NULL,
  `id` bigint(20) NOT NULL PRIMARY KEY,
  CONSTRAINT `CS_STEP_FK` FOREIGN KEY (`id`) REFERENCES `pipeline_step` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `deployment_step` (
  `ignore_validation_error` boolean NOT NULL DEFAULT TRUE,
  `offline_install` boolean NOT NULL DEFAULT FALSE,
  `twx_path` varchar(255) DEFAULT NULL,
  `id` bigint(20) NOT NULL PRIMARY KEY,
  
  CONSTRAINT `DEPLOYMENT_STEP_FK` FOREIGN KEY (`id`) REFERENCES `pipeline_step` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `script_step` (
  `script` text NOT NULL,
  `id` bigint(20) NOT NULL PRIMARY KEY,
  CONSTRAINT `SCRIPT_STEP_FK` FOREIGN KEY (`id`) REFERENCES `pipeline_step` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `build` (
  `id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `duration` varchar(20) DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `exception_trace` text,
  `start_date` datetime NOT NULL,
  `status` varchar(10) DEFAULT NULL,
  `pipeline_id` bigint(20) NOT NULL,
  CONSTRAINT `BUILD_PIPELINE_FK` FOREIGN KEY (`pipeline_id`) REFERENCES `pipeline` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `build_stage` (
  `id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `stage_type` varchar(10) NOT NULL,
  `stage_index` int(11) DEFAULT NULL,
  `build_id` bigint(20) NOT NULL,
  CONSTRAINT `BUILD_STAGE_FK` FOREIGN KEY (`build_id`) REFERENCES `build` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `build_step` (
  `id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `duration` varchar(255) DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `build_step_index` int(11) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `status` varchar(10) NOT NULL,
  `exception_trace` text,
  `step_type` varchar(20) NOT NULL,
  `stage_id` bigint(20) NOT NULL,
  CONSTRAINT `BUILD_STEP_FK` FOREIGN KEY (`stage_id`) REFERENCES `build_stage` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `test_build_step` (
  `id` bigint(20) NOT NULL PRIMARY KEY ,
  `test_result_id` bigint(20) DEFAULT NULL,
  CONSTRAINT `UT_BUILD_STEP_RESULT_FK` FOREIGN KEY (`test_result_id`) REFERENCES `test_result` (`id`),
  CONSTRAINT `UT_BUILD_STEP_FK` FOREIGN KEY (`id`) REFERENCES `build_step` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `snapshot_build_step` (
  `bpm_snapshot_id` varchar(50) DEFAULT NULL,
  `bpm_snapshot_name` varchar(255) DEFAULT NULL,
  `id` bigint(20) NOT NULL PRIMARY KEY,
  CONSTRAINT `SNAPSHOT_BUILD_STEP_FK` FOREIGN KEY (`id`) REFERENCES `build_step` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `checkstyle_build_step` (
  `artifacts` int(11) DEFAULT NULL,
  `report_data` longtext,
  `report_folder` varchar(255) DEFAULT NULL,
  `score` int(11) DEFAULT NULL,
  `warnings` int(11) DEFAULT NULL,
  `id` bigint(20) NOT NULL PRIMARY KEY,
  CONSTRAINT `CS_BUILD_STEP_FK` FOREIGN KEY (`id`) REFERENCES `build_step` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `deployment_build_step` (
  `id` bigint(20) NOT NULL PRIMARY KEY,
  CONSTRAINT `DEPLOYMENT_BUILD_STEP_FK` FOREIGN KEY (`id`) REFERENCES `build_step` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `script_build_step` (
  `id` bigint(20) NOT NULL PRIMARY KEY,
  `result` text DEFAULT NULL,
  `script` text DEFAULT NULL,
  CONSTRAINT `SCRIPT_BUILD_STEP_FK` FOREIGN KEY (`id`) REFERENCES `build_step` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `monitor`(
   `id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
   `name` varchar(100) not null,
   `descrption` varchar(225),
   `server` varchar(64) DEFAULT null,
   `process_app` varchar(64) DEFAULT NULL,
   `branch` varchar(64) DEFAULT NULL,
   `failed_instance_notification_to` varchar(128) DEFAULT NULL,
   `default_execution_timeout` int not null,
   `timeout_notification_to` varchar(128) DEFAULT NULL,
   `creator` varchar(64) not null,
   `snapshot` varchar(64) DEFAULT NULL,
   `monitor_failed_instance` boolean DEFAULT FALSE,
   `enable` boolean DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `component_entity` (
	`id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`component_name` varchar(200) not null,
	`execution_timeout` int DEFAULT 0,
	`checked` boolean DEFAULT FALSE,
	`monitor_id` bigint(20),
	CONSTRAINT `MONITOR_ID_FK` FOREIGN KEY (`monitor_id`) REFERENCES `monitor` (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `bpm_event` (
	`id` bigint(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`systemid` varchar(225),
	`correlationid` varchar(225),
	`occurancetime` varchar(225),
	`instanceid` varchar(225),
	`taskid` varchar(225),
	`instancestatus` varchar(225),
	`taskstatus` varchar(225),
	`sequenceid` varchar(225),
	`appname` varchar(225),
	`appid` varchar(225),
	`appversion` varchar(225),
	`componenttype` varchar(225),
	`componentname` varchar(225),
	`elementtype` varchar(225),
	`elementname` varchar(225),
	`eventtype` varchar(225),
	`duration` varchar(225),
	`executiontime` varchar(225),
	`waittime` varchar(225),
	`starttime` varchar(225),
	`endtime` varchar(225),
	`errortrace` varchar(225),
	`envname` varchar(225)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `testing_configuration_multiple_selenium_gird_config`
--

CREATE TABLE `testing_configuration_multiple_selenium_gird_config` (
	`testing_configuration_id` bigint(20) NOT NULL,
	`multiple_selenium_gird_config_id` bigint(20) NOT NULL,
	CONSTRAINT `TESTING_CONFIGURATION_MULTIPLE_SELENIUM_GIRD_CONFIG_FK` FOREIGN KEY (`multiple_selenium_gird_config_id`) REFERENCES `selenium_grid_config` (`id`),
	CONSTRAINT `MULTIPLE_SELENIUM_GIRD_CONFIG_TESTING_CONFIGURATION_FK` FOREIGN KEY (`testing_configuration_id`) REFERENCES `testing_configuration` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
