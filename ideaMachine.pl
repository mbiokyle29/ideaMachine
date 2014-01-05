#!/usr/bin/env perl
use Mojolicious::Lite;
use DBI;
my $user = "ideaMac";
my $pass = "deusXmach";

my $dbh = DBI->connect("DBI:mysql:Idea", $user, $pass);

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
	if($$idea[0])
	{
		$self->stash(idea => $idea);
		$self->stash(comment_ref => $comments);
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

sub select_comments
{
	my $idea_id = shift;
	my $q = "SELECT text, user from comments WHERE idea_id=?";
	my $sth = $dbh->prepare($q);
	$sth->execute($idea_id);
	my $arr_ref = $sth->fetchall_arrayref;
	return $arr_ref;
}

sub insert_comment
{
	my $idea_id = shift;
	my $comment = shift;
	my $commenter = shift;
	my $q = "INSERT INTO comments (idea_id, text, user) values (?,?,?)";
	my $sth = $dbh->prepare($q);
	$sth->execute($idea_id, $comment, $commenter);
}

sub insert_idea
{
	my $title = shift;
	my $description = shift;
	my $user = shift;
	my $q = "INSERT INTO ideas (title, description, user) values (?,?,?)";
	my $sth = $dbh->prepare($q);
	$sth->execute($title, $description, $user);
	return $dbh->{'mysql_insertid'};
}

sub select_ideas
{
	my $q = "SELECT id, title, description, user from ideas LIMIT 10";
	my $sth = $dbh->prepare($q);
	$sth->execute();
	my $arr_ref = $sth->fetchall_arrayref;
	return $arr_ref;
}

sub select_idea
{
	my $id = shift;
	my $q = "SELECT id, title, description, user from ideas WHERE id=?";
	my $sth = $dbh->prepare($q);
	$sth->execute($id);
	my $arr_ref = $sth->fetchrow_arrayref;
	return $arr_ref;
}
app->start;