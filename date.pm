package Date; 

use 5.010;
use experimental qw(smartmatch);
use strict;  

use overload 
  '""'   => \&getDate,
  '-'    => \&subtract,
  '+'    => \&addDay,
  '=='   => \&equal,
  '<'    => \&less;


my @WEEKDAYS = ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');

sub new 
{
    my ($class, $date) = @_;
	$date = '1.1.1' unless defined $date; 
	my $self = {};                  
	bless $self, $class;
	($self->{year}, $self->{month}, $self->{day}) = split(/\./, $date);
	$self->{weekday} = weekday($self);

    die "Incorrect day: $self->{day}" if ($self->{day} < 1 || $self->{day} > daysInMonth($self->{month}, $self->{year}));
    die "Incorrect month: $self->{month}" if $self->{month} > 12 || $self->{month} < 1;
    die "Incorrect year: $self->{year}" if $self->{year} < 1; 
    
    $self;
}

sub printDate
{
	my ($date) = @_;
	say "$date";
}

sub getDate 
{
	my ($self) = @_;
	my $delimiter = '.';
	my $date = $self->{year} . $delimiter . $self->{month} . $delimiter . $self->{day};
}

sub daysInMonth 
{
	my ($month, $year) = @_;
	return 31 if $month ~~ [1, 3, 5, 7, 8, 10, 12];
	return 30 if $month ~~ [4, 6, 9, 11];
	return (leapYear($year) ? 29 : 28) if ($month == 2);
}

sub equal
{
	my ($date1, $date2) = @_;
	$date1->{day} == $date2->{day} && $date1->{month} == $date2->{month} && $date1->{year} == $date2->{year};
}

sub leapYear
{
	my ($year) = @_;
	($year % 100 != 0 && $year % 4 == 0) || $year % 400 == 0;
}

sub dateToDays
{
	my ($date) = @_;
	my $days = $date->{day};
	for (1..$date->{year})
	{
		$days += 365 + leapYear($_);
	}
	for (1..$date->{month} - 1)
	{
		$days += daysInMonth($_, $date->{year});
	} 
	$days;
}

sub subtract 
{ 
	my ($date1, $date2) = @_;
	abs(dateToDays($date1) - dateToDays($date2));
}

sub addDay
{
    my ($date, $days) = @_;
	$days += $date->{day};
	
	my $month = $date->{month};
	my $year = $date->{year};
	while ($days > daysInMonth($month, $year))
	{
		$days -= daysInMonth($month, $year);
		if ($month++ > 12) 
		{
			$month = 1;
			$year++;
		}
	}
	Date->new("$year.$month.$days");
}

sub addMonths
{ 
	my ($date, $month) = @_;
	my $year = 0;
	$month += $date->{month};
	if ($month > 12)
	{
		$year = int($month / 12);
		$month = $month % 12;
	}
	$year += $date->{year};
  	Date->new("$year.$month.$date->{day}");
}

sub addYears
{ 
	my ($date, $year) = @_;
	$year += $date->{year};
  	Date->new("$year.$date->{month}.$date->{day}");
}

sub weekday
{
	my ($date) = @_;
	my $a = int((14 - $date->{month}) / 12);
    my $y = $date->{year} - $a;
    my $m = $date->{month} + 12 * $a - 2;
    my $R = 7000 + ($date->{day} + $y + int($y / 4) - int($y / 100) + int($y / 400) + int((31 * $m) / 12) );
    $WEEKDAYS[$R % 7];
}

1;