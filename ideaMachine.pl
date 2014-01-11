#!/usr/bin/env perl
use Mojolicious::Lite;
use DBI;

get '/' => sub
{
	my $self = shift;
	my $ref = &select_ideas;
	$self->stash(ideas => $ref);
	$self->render('index');
};

post '/idea' => sub
{
	my $self = shift;
	my $idea = $self->param('title');
	my $desc = $self-> param('description');
	my $submitter = $self->param('user');
	my $id = insert_idea($idea, $desc, $submitter);
	$self->redirect_to("/idea/$id");
};

get '/idea/:id/' => sub
{
	my $self = shift;
	my $id = $self->param('id');
	my $idea = &select_idea($id);
	my $comments = &select_comments($id);
  my $tags = &select_tags($id);
	if($$idea[0])
	{
		$self->stash(idea => $idea);
		$self->stash(comment_ref => $comments);
		$self->stash(tags => $tags);
    $self->render('idea');
	}
	else { $self->render(text => "Sorry page not found"); }
};

post '/comment' => sub
{
	my $self = shift;
	my $idea_id = $self->param('id');
	my $comment = $self->param('comment');
	my $commenter = $self->param('commenter');
	&insert_comment($idea_id, $comment, $commenter);
	$self->redirect_to("/idea/$idea_id");
};

post '/tag' => sub
{
	my $self = shift;
	my $idea_id = $self->param('id');
	my $tag = $self->param('tag');
  &insert_tag($idea_id, $tag);
	$self->redirect_to("/idea/$idea_id");
};


sub connect
{
	my $user = "bf391e6568fd14";
	my $pass = "6289e0fc";
	my $host = "us-cdbr-east-04.cleardb.com";
	my $db = "heroku_165a36048510275";
	my $dsn = "DBI:mysql:database=$db;host=$host;";
	my $dbh = DBI->connect($dsn, $user, $pass);
	return $dbh;
}

sub select_comments
{
	my $dbh = &connect();
	my $idea_id = shift;
	my $q = "SELECT text, user from comments WHERE idea_id=?";
	my $sth = $dbh->prepare($q);
	$sth->execute($idea_id);
	my $arr_ref = $sth->fetchall_arrayref;
	return $arr_ref;
}

sub insert_comment
{
	my $dbh = &connect();
	my $idea_id = shift;
	my $comment = shift;
	my $commenter = shift;
	my $q = "INSERT INTO comments (idea_id, text, user) values (?,?,?)";
	my $sth = $dbh->prepare($q);
	$sth->execute($idea_id, $comment, $commenter);
}

sub insert_idea
{
	my $dbh = &connect();
	my $title = shift;
	my $description = shift;
	my $user = shift;
	my $q = "INSERT INTO ideas (title, description, user) values (?,?,?)";
	my $sth = $dbh->prepare($q);
	$sth->execute($title, $description, $user);
	return $dbh->{'mysql_insertid'};
}

sub insert_tag
{
	my $dbh = &connect();
	my $idea_id = shift;
	my $tag = shift;
	my $q = "INSERT INTO tags (idea_id, tag) values (?,?)";
	my $sth = $dbh->prepare($q);
	$sth->execute($idea_id, $tag);
}

sub select_ideas
{
	my $dbh = &connect();
	my $q = "SELECT id, title, description, user from ideas LIMIT 10";
	my $sth = $dbh->prepare($q);
	$sth->execute();
	my $arr_ref = $sth->fetchall_arrayref;
	return $arr_ref;
}

sub select_idea
{
	my $dbh = &connect();
	my $id = shift;
	my $q = "SELECT id, title, description, user from ideas WHERE id=?";
	my $sth = $dbh->prepare($q);
	$sth->execute($id);
	my $arr_ref = $sth->fetchrow_arrayref;
	return $arr_ref;
}

sub select_tags
{
  	my $dbh = &connect();
    my $id = shift;
    my $q = "SELECT tag from tags where idea_id=?";
    my $sth = $dbh->prepare($q);
    $sth->execute($id);
    my $arr_ref = $sth->fetchall_arrayref;
    return $arr_ref;
}
app->start;
