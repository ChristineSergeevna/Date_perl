use 5.010;
use strict;
use Date;
use Test::More "no_plan";
	
sub testing
{
	my ($date1, $date2, $days, $months, $years, @ans) = @_;
	is($date1->weekday, $ans[0], 'Weekday');
	my $date = $date1 + $days;
	is("$date", $ans[1], 'addDays');
	$date = $date1->addMonths($months);
	is("$date", $ans[2], 'addMonths');
	$date = $date1->addYears($years);
	is("$date", $ans[3], 'addYears');
	$date = $date1 - $date2;
	is($date, $ans[4], 'subtract');
}

testing(Date->new('2020.2.29'), Date->new('2025.2.28'), 1, 350, 4, 'Saturday', '2020.3.1', '2049.4.29', '2024.2.29', 1825);
testing(Date->new('1980.11.10'), Date->new('2016.11.30'), 365, 3000, 36, 'Monday', '1981.11.10', '2230.11.10', '2016.11.10', 13169);
testing(Date->new('2016.11.9'), Date->new('2016.11.9'), 10000, 24, 1984, 'Wednesday', '2044.3.27', '2018.11.9', '4000.11.9', 0);
testing(Date->new('2016.11.9'), Date->new('2016.11.10'), -8, -10, -2015, 'Wednesday', '2016.11.1', '2016.1.9', '1.11.9', 1);
testing(Date->new('1989.1.1'), Date->new('2016.1.1'), 0, 0, 0, 'Sunday', '1989.1.1', '1989.1.1', '1989.1.1', 9862);
testing(Date->new('2020.12.31'), Date->new('2016.12.31'), 366, 25, 1, 'Thursday', '2022.1.1', '2023.1.31', '2021.12.31', 1461);
testing(Date->new('2003.1.1'), Date->new('2001.12.31'), 90, 11, 113, 'Wednesday', '2003.4.1', '2003.12.1', '2116.1.1', 366);