#!/usr/bin/perl -w
use LWP;
use HTTP::Cookies;
use Cwd;
#use Encode;
#use utf8;

##-------------------------------------------------------------------------------
## get date/time
    use Time::Local; 
    my  ($sec,$min,$hour,$mday,$mon,$year) = (localtime)[0..5];
    $year = $year + 1900;
    $mon  = $mon  + 1;
	#print "$year/$mon/$mday $hour:$min:$sec";
	
	use POSIX qw(strftime);
	my $yestoday = strftime("%Y.%m.%d", localtime(time - 24*3600));#获取昨天的日期
	my $today = strftime("%Y.%m.%d", localtime(time));#获取昨天的日期
##-------------------------------------------------------------------------------
## 设定变量&ei=UTF-8
    my @search_link_all			=	(	'http://www.sony.com'					      ,
									);

	
	my $agent_info				=	'Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko' ;
	my @product_link_all        =	(	);
	#my @excel_info              =   ( ["", "", "", "", ""]);
	my @excel_info              =   (   );
    my $dir = getdcwd();
##-------------------------------------------------------------------------------
## Step1 ：文件处理
##-------------------------------------------------------------------------------
	print "STEP1：正在打开文件... ...";
	open my $FILE , " > $dir\\new.html " or die "cannot open file $! for debug !\n" ;


my $ua=new LWP::UserAgent;
$ua->agent($agent_info);
#my $cookie_jar = HTTP::Cookies->new(file=>" $dir\\yahoo.Cookie" , autosave=>1, ignore_discard=>1);
#$ua->cookie_jar($cookie_jar);
#$ua->default_header('Accept-Language' => "ja-JP");
#$ua->default_header('Accept-Encoding' => "gzip");
foreach my $url_itr (@search_link_all){

	##打开指定网页
    my $res_board   = $ua->get($url_itr);
    $html_board  = $res_board->content;
#   $html_board  = $res_board->decoded_content;
#	$html_board = encode("utf8",$html_board);
#	if(Encode::is_utf8($html_board)) {print "flag is true";}
#	$html_board=encode('Shift-JIS',$html_board);
#	print $FILE $html_board;
	#print "获取网页数据 \n";
#	return encode_utf8($html_board);
#	print $FILE $html_board ;
#print $FILE encode("utf-8",decode("utf-8",$html_board));
	print "opening $url_itr\n";

	##check 是否真确返回网页内容
	#print $res_board->status_line ;
    if($res_board->status_line ne '200 OK') {
        print "Error Network \n" ;
        sleep 90;
        next ;
	}

}


