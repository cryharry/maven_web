-- Create initial schema.
-- DON'T EDIT. MAKE A NEW SCRIPT FOR EVERY SCHEMA CHANGE.

-- Wiki
drop table if exists wiki ;
create table wiki (
	id varchar(20) not null,
	name varchar(100) not null,
	description text null,
	type varchar(10) not null,
	layout enum('LEFT', 'RIGHT') not null,
	color_set enum('WHITE', 'LIGHT_GRAY', 'SKY_BLUE', 'DARK_GRAY', 'BLACK') not null,
	created_time datetime not null,
	modified_time datetime null,
	primary key (id),
  constraint unique (name)
);

-- Wiki category
drop table if exists wiki_category;
create table wiki_category (
	id integer not null auto_increment,
	parent_id integer not null,
	name varchar(100) not null,
	primary key (id)
);

-- Wiki keyword
drop table if exists wiki_keyword;
insert into wiki_category values(null, 0, 'category_1');
insert into wiki_category values(null, 0, 'category_2');
insert into wiki_category values(null, 0, 'category_3');
insert into wiki_category values(null, 1, 'category_1_1');
insert into wiki_category values(null, 1, 'category_1_2');
insert into wiki_category values(null, 1, 'category_1_3');
insert into wiki_category values(null, 2, 'category_2_1');
insert into wiki_category values(null, 3, 'category_3_1');

-- Wiki categorization
drop table if exists wiki_categorization;
create table wiki_categorization (
	wiki_id varchar(20) not null,
  category_id integer not null
);

-- Wikizen
drop table if exists wikizen;
create table wikizen (
	-- FK to NaverUser.id
	id varchar(12) not null,
	nick_name varchar(32) null,
	picture_url varchar(1024) null,
	primary key(id)
);

-- Wiki membership
drop table if exists wiki_membership;
create table wiki_membership (
	wiki_id varchar(20) not null,
	member_id varchar(12) not null,
-- role varchar(20) not null,
	primary key (wiki_id, member_id)
);

-- Wiki blacklist drop
-- drop table if exists wiki_block;

-- Wiki block
drop table if exists wiki_blocked_user;
create table wiki_blocked_user (
	id int not null auto_increment,
	wiki_id varchar(20) not null,
	blocked_id varchar(12) not null,	
	unblocked boolean not null,
	unblock_asked boolean not null,
	reason tinytext not null,
	blocker_id varchar(20) not null,
	blocked_time datetime not null,
	unblocker_id varchar(20) null,
	unblocked_time datetime null,
	primary key (id)
);


-- Page
drop table if exists page;
create table page (
	id bigint not null auto_increment,
	parent_id bigint not null,
	order_no int not null,
	wiki_id varchar(20) not null,
	name varchar(255) not null,
	intention varchar(255) null,
	--FK to page_revision.id. 0 if it have no revision
	latest_revision_id bigint not null,
	modified_time datetime null,
	hit_count int not null,
	bookmark_point int not null,
	deleted boolean not null default false,
	protected boolean not null default false,
	primary key (id)
);

drop table if exists page_revision;
create table page_revision (
	id bigint not null auto_increment,
	/** FK to wiki.id */
	wiki_id varchar(20) not null,
	/** FK to page.id */
	page_id bigint not null,
	revision int unsigned not null default 1,
	created_time datetime not null,
	event enum('EDITED', 'MOVED', 'DELETED', 'UNDELETED', 'PURGED', 'PROTECTED', 'UNPROTECTED') not null,
	editor_id varchar(12) not null,
	edit_summary tinytext null,
	minor_edit boolean not null,
	name varchar(255) not null,
	/** FK to page_text.id */
	text_id text not null,
	primary key (id)
);

drop table if exists page_text;
create table page_text (
	id bigint not null auto_increment,
	body mediumtext not null,
	primary key (id)
);

drop table if exists page_bookmark;
create table page_bookmark (
	/** FK to page.id */
	page_id bigint not null,
	/** FK to user.id */
	user_id varchar(12) not null,
	timestamp datetime not null,
	primary key (page_id, user_id)
);

-- wiki proposal
drop table if exists wiki_proposal;
create table wiki_proposal (
	wiki_id varchar(20) not null,
	status enum('PROPOSED', 'ACCEPTED', 'REJECTED') not null,
	proposer_id varchar(12) not null,
	proposed_time datetime not null,
	auditor_id varchar(12),
	audited_time datetime,
	audit_comment text,
	primary key (wiki_id)
);

drop table if exists wiki_event;
create table wiki_event (
	id int not null auto_increment,
	type enum('GO_PUBLIC', 'WIKI_PUNISHED', 'PAGE_PUNISHED', 'PAGENAME_CHANGED') not null,
	reason tinytext not null,
	wiki_id varchar(20) not null,
	page_id bigint null,
	created_time datetime not null,
	closed_time datetime null,
	latest_proceeding_id int not null,
	primary key(id)
);

drop table if exists wiki_proceeding;
create table wiki_proceeding (
	id int not null auto_increment,
	--FK to wiki_event.id
	event_id int not null,
	proposer_id varchar(12) not null,
	proposed_time datetime not null,
	proposed_comment text null,
	status enum('PROPOSED', 'ACCEPTED', 'REJECTED') not null,
	auditor_id varchar(12) null,
	audited_time datetime null,
	audit_comment text null,
	primary key(id)
);

drop table if exists wiki_contribution;
create table wiki_contribution (
	wiki_id varchar(20) not null,
	contributor_id varchar(12) not null,
	point int not null,
	modified_time datetime not null,
	primary key (wiki_id, contributor_id)
);

drop table if exists page_contribution;
create table page_contribution (
	wiki_id varchar(20) not null,
	page_id bigint not null,
	contributor_id varchar(12) not null,
	point int not null,
	modified_time datetime not null,
	primary key (wiki_id, page_id, contributor_id)
);
