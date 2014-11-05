-- page_temporary
drop table if exists page_temporary ;
create table page_temporary (
	id bigint not null auto_increment,
	user_id varchar(12) not null,
	wiki_id varchar(20) not null,
	page_id bigint not null,
	name varchar(255) not null,
	intention varchar(255) null,
	content mediumtext not null,
	edit_summary tinytext null,
	minor_edit boolean not null,
	primary key (id)
);