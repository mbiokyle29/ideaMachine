This repository contains a small perl mojolicous web application to track hackathon ideas.

Installation
```bash
curl get.mojolicio.us | sh
sudo apt-get install lib-mojoliciousperl
```

Create the mysql database
```sql
CREATE USER 'ideaMac'@'localhost' IDENTIFIED BY 'deusXmach'
CREATE database Idea;
use Idea;
CREATE TABLE ideas
(
	id int auto_increment,
	primary key(id),
	title varchar(250),
	description text,
	user varchar(250)
);

#comments
CREATE TABLE comments
(
	id int auto_increment NOT NULL,
	primary key(id),
	idea_id int NOT NULL,
	text varchar(1000) NOT NULL,
	user varchar(250) NOT NULL
);

#Tags
CREATE TABLE tags
{
  id int auto_increment NOT NULL,
	primary key(id),
	idea_id int NOT NULL,
  tag varchar(250) NOT NULL
};

GRANT ALL ON Idea.* to 'ideaMac'@'localhost'
```


Start the development server
```bash
morbo IdeaMachine
```
