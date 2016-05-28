CREATE TABLE schema_migrations (
	version INT NOT NULL PRIMARY KEY
)
INSERT INTO schema_migrations (version) VALUES (1);
INSERT INTO schema_migrations (version) VALUES (2);

CREATE TABLE users (
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	username VARCHAR(128) NOT NULL UNIQUE,
	password VARCHAR(256) NOT NULL,
	email VARCHAR(128) NOT NULL,
	time_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	credit BIGINT NOT NULL DEFAULT 0,
	vm_limit INT NOT NULL DEFAULT 5,
	last_billing_notify TIMESTAMP DEFAULT 0,
	billing_low_count INT NOT NULL DEFAULT 0,
	time_billed TIMESTAMP DEFAULT 0,
	status ENUM('new', 'active', 'disabled') NOT NULL DEFAULT 'new',
	admin TINYINT(1) DEFAULT 0
);

CREATE TABLE api_keys (
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	label VARCHAR(64) NOT NULL DEFAULT '',
	user_id INT NOT NULL,
	api_id VARCHAR(16) NOT NULL UNIQUE,
	api_key VARCHAR(128) NOT NULL,
	restrict_action VARCHAR(512) NOT NULL,
	restrict_ip VARCHAR(512) NOT NULL,
	time_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	nonce BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE sessions (
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	uid VARCHAR(64) NOT NULL UNIQUE,
	user_id INT NOT NULL,
	admin TINYINT(1) NOT NULL,
	original_id INT NOT NULL,
	regenerate TINYINT(1) NOT NULL,
	active_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE form_tokens (
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	token VARCHAR(64) NOT NULL UNIQUE,
	session_uid VARCHAR(64) NOT NULL,
	time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pwreset_tokens (
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	user_id INT NOT NULL UNIQUE,
	token VARCHAR(32) NOT NULL UNIQUE,
	time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tickets (
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	user_id INT NOT NULL,
	name VARCHAR(256) NOT NULL,
	status ENUM('open', 'answered', 'closed') NOT NULL DEFAULT 'open',
	time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	modify_time TIMESTAMP,
	KEY (user_id)
);

CREATE TABLE ticket_messages (
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	ticket_id INT NOT NULL,
	staff TINYINT(1) NOT NULL,
	message TEXT NOT NULL,
	time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	KEY (ticket_id)
);

CREATE TABLE region_bandwidth (
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	user_id INT NOT NULL,
	region VARCHAR(64) NOT NULL,
	bandwidth_used BIGINT NOT NULL DEFAULT 0,
	bandwidth_additional BIGINT NOT NULL DEFAULT 0,
	bandwidth_billed BIGINT NOT NULL DEFAULT 0,
	bandwidth_notified_percent INT NOT NULL DEFAULT 0,
	KEY (user_id, region)
);

CREATE TABLE actions (
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	user_id INT NOT NULL DEFAULT 0,
	ip VARCHAR(32) NOT NULL,
	name VARCHAR(256) NOT NULL,
	details VARCHAR(1024) NOT NULL,
	time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE vms (
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	user_id INT NOT NULL,
	region VARCHAR(64) NOT NULL,
	plan_id INT NOT NULL,
	name VARCHAR(128) NOT NULL,
	identification VARCHAR(128) NOT NULL DEFAULT '',
	status ENUM('unknown', 'provisioning', 'active', 'error') NOT NULL DEFAULT 'unknown',
	task_pending TINYINT(1) NOT NULL DEFAULT 0,
	external_ip VARCHAR(32) NOT NULL DEFAULT 'unknown',
	private_ip VARCHAR(32) NOT NULL DEFAULT 'unknown',
	time_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	time_billed TIMESTAMP DEFAULT 0,
	suspended ENUM ('no', 'manual', 'auto') NOT NULL DEFAULT 'no',
	KEY (user_id)
);

CREATE TABLE vm_metadata (
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	vm_id INT NOT NULL,
	k VARCHAR(64) NOT NULL,
	v VARCHAR(256) NOT NULL,
	KEY (vm_id)
);

CREATE TABLE plans (
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(64) NOT NULL,
	price BIGINT NOT NULL,
	ram INT NOT NULL,
	cpu INT NOT NULL,
	storage INT NOT NULL,
	bandwidth INT NOT NULL,
	global TINYINT(1) NOT NULL DEFAULT 1,
	enabled TINYINT(1) NOT NULL DEFAULT 1
);

CREATE TABLE region_plans (
	plan_id INT NOT NULL,
	region VARCHAR(64) NOT NULL,
	identification VARCHAR(128) NOT NULL DEFAULT ''
);

CREATE TABLE images (
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	user_id INT NOT NULL DEFAULT -1,
	region VARCHAR(64) NOT NULL,
	name VARCHAR(64) NOT NULL,
	identification VARCHAR(128) NOT NULL DEFAULT '',
	status ENUM ('pending', 'active', 'error') NOT NULL DEFAULT 'active',
	source_vm INT NOT NULL DEFAULT -1
);

CREATE TABLE charges (
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	user_id INT NOT NULL,
	name VARCHAR(256) NOT NULL,
	detail VARCHAR(512) NOT NULL DEFAULT '',
	k VARCHAR(32) NOT NULL DEFAULT '',
	time DATE NOT NULL,
	amount BIGINT NOT NULL,
	KEY (user_id),
	KEY (time)
);

CREATE TABLE transactions (
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	user_id INT NOT NULL,
	gateway VARCHAR(64) NOT NULL,
	gateway_identifier VARCHAR(256) NOT NULL DEFAULT '',
	notes VARCHAR(256) NOT NULL DEFAULT '',
	amount BIGINT NOT NULL,
	fee BIGINT NOT NULL DEFAULT 0,
	time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	KEY (user_id),
	KEY (time)
);

CREATE TABLE antiflood (
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	ip VARCHAR(32) NOT NULL,
	action VARCHAR(64) NOT NULL,
	count INT NOT NULL,
	time TIMESTAMP NOT NULL
);

CREATE TABLE regions (
	region VARCHAR(128) NOT NULL UNIQUE,
	enabled TINYINT(1) NOT NULL DEFAULT 1
);

CREATE TABLE sshkeys (
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	user_id INT NOT NULL,
	name VARCHAR(64) NOT NULL,
	val VARCHAR(2048) NOT NULL
);
