#!/usr/bin/perl -w
use LWP;
use HTTP::Cookies;
use Cwd;

##------------------------------------------------------------------
## get date/time
    use Time::Local; 
    my  ($sec,$min,$hour,$mday,$mon,$year) = (localtime)[0..5];
    $year = $year + 1900;
    $mon  = $mon  + 1;


##------------------------------------------------------------------
## �趨ѡȡ�ĸ��ʺ�
    die "û���趨ѡȡ�ʺ�!\n " if (@ARGV!=1) ;
    my $id_number = $ARGV[0];
    print "ID number : $id_number \n" ;


##------------------------------------------------------------------
## define variable
    #my $time_stamp       = "2013-8-9" ;
    #my $chongzhika       = "MIDE-595" ;
    #my $Qbi              = "�ǆD����" ;
    #my $seller           = "��Ƭ" ;

    my $time_stamp       = "$year-$mon-$mday" ;
    my $chongzhika       = "��ֵ��" ;
    my $yikachong        = "һ����" ;
    my $Qbi              = "Q��" ;
    my $wushiyuan        = "50Ԫ";
    my $liushiyuan       = "60Ԫ";
    my $sanshiyuan       = "30Ԫ";
    my $shiyuan          = "10Ԫ";
    my $seller           = "����" ;
    
    my @site_all         = ( 'http://www.sis001.com' ,
	                     'http://68.168.16.158'  ,
                           );

    my @username_all     = ( 'sis086'     ,
                             ''   ,
                           );
    my @password_all     = ( 'yalasi'  ,
                             ''     ,
                           );
    my @message_all      = ( '�������ˣ���л¥��������������������������                               ' ,
                           ) ;
    my @agent_info_all   = ( 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/535.12 (KHTML, like Gecko) Maxthon/3.0 Chrome/22.0.1229.79 Safari/535.12' ,
                             'Maxthon/2.0.4.8' ,
                           ) ;

    my $site             = $site_all[$id_number];
    my $username         = $username_all[$id_number];
    my $password         = $password_all[$id_number];
    my $message          = $message_all[$id_number];
    my $agent_info       = $agent_info_all[$id_number];
    my $url_board        = $site.'/forum/forum-491-1.html'; 



    my $dir = cwd;
    my $formhash_login;
    my $formhash;


##------------------------------------------------------------------
## Windows32�������趨
    use Win32;
    use Win32::Sound;
    Win32::Sound::Volume('100%');


##------------------------------------------------------------------
## ��ӡ�����Ϣ
    print "="x75;
    print "\n";
    print "* ������     :   ��̳����Զ���������\n";
    print "* ���ؼ��� :   $seller    $time_stamp\n";
    print "* ���ؼ��� :   $chongzhika|$yikachong|$Qbi|$wushiyuan|$liushiyuan|$sanshiyuan|$shiyuan\n";
    print "* �����ַ   :   $url_board\n";
    print "* �û���     :   $username\n";
    print "* ����       :   $password\n";
    print "* �ظ���Ϣ   :   $message\n";
    print "* UserAgent  :   $agent_info\n";
    print "="x75;
    print "\n";

#    sleep 10;


##------------------------------------------------------------------
## Debug file
    open my $FILE , " > $dir\\source.html " or die "cannot open file source.html for debug !\n" ;


##------------------------------------------------------------------
    my $ua=new LWP::UserAgent;
#    $ua->agent('Mozilla/5.0');
    $ua->agent($agent_info);
    my $cookie_jar = HTTP::Cookies->new(file=>" $dir\\sis001.Cookie" , autosave=>1, ignore_discard=>1);
    $ua->cookie_jar($cookie_jar);


##-----------------------------------------------------------------
#��½ǰ,ȡ��Login֮ǰ��formhashֵ,����login
    my $res_login  = $ua->get( $site.'/forum/logging.php?action=login') ;
    my $html_login = $res_login->content;
    die "ץ����formhash" unless $html_login =~ m{formhash=([\d\w]{8})\"?}gi; 
    $formhash_login= $1;
    print "LoginǰWebsite  : $site/forum/logging.php?action=login\n" ;
    print "Loginǰformhash : $formhash_login\n" ;


##------------------------------------------------------------------
#��ʽ��½
    my $login_post=$ua->post( $site.'/forum/logging.php?action=login',
         [
         "referer"                            => "index.php",
         "loginfield"                         => "username",
         "62838ebfea47071969cead9d87a2f1f7"   => $username,
         "c95b1308bda0a3589f68f75d23b15938"   => $password,
         "formhash"                           => $formhash_login,
         "questionid"                         => "0",
         "answer"                             => "", 
         "cookietime"                         => "2592000",
         "loginmode"                          => "",
         "styleid"                            => "",
         "loginsubmit"                        => "true",
         ]
        );
   sleep 3 ;


##------------------------------------------------------------------
#��½��ɺ�,������,ץȡformhash

while(1) {

    my $res_board   = $ua->get($url_board); ##��ָ����ҳ
    my $html_board  = $res_board->content;
#    print "��ȡ������� \n";
    print $FILE $html_board ;
    $html_board =~ m{formhash=([\d\w]{8})\"?}gi; 
    $formhash  = $1;
    print $res_board->status_line ;
    if($res_board->status_line ne '200 OK') {
        print "��������������~ \n" ;
        sleep 20;
        next ;
    }
    print "Login��Website  : $url_board\n" ;
    print "Login��formhash : $formhash\n" ;
    print "Login�󷵻�ֵ   : " . $res_board->status_line . "\n" ;


##------------------------------------------------------------------

    if($html_board =~ m/$seller.*($chongzhika|$yikachong|$Qbi|$wushiyuan|$liushiyuan|$sanshiyuan|$shiyuan).*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*$time_stamp/) {








        ##�ʼ�����
        #Send_Mail();

        ##��������
        for(my $i=0; $i<10; $i++) {
            sleep 0.5;
            Win32::Sound::Play(SystemAsterisk);
        }

        ### For Just Test





    ##�Ѳ��ҵ�ָ����Ϣ
        sleep 60;


        $html_board    =~ m/$seller.*($chongzhika|$yikachong|$Qbi|$wushiyuan|$liushiyuan|$sanshiyuan|$shiyuan).*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*$time_stamp.*\n.*\n.*\n.*\n.*href=.redirect.php.tid=(\d+).amp/ ;
        my $tid        = $2;
        print "Thread          : $tid (tid)\n" ;

        my $url_thread = $site."/forum/thread-$tid-1-1.html" ;
        print "URL_Checked     : $url_thread\n";
        my $res_thread = $ua->get($url_thread); 
        my $content    = $res_thread->content;

        $content =~ m{<form method="post" id="postform" action="(.+)" onSubmit.*\n.*input type="hidden" name="(.+)" value}gi ;
        my $reply_info_1 = $1; ## reply url
        my $reply_info_2 = $2; ## formhash
        $reply_info_1    =~ s/amp;//g;
        print "$reply_info_1 \n$reply_info_2\n";

        my $post_url     = $site.'/forum/'.$reply_info_1 ; 
        print "Found URL       : $post_url \n";

        ##�ظ�����
        my $response=$ua->post( $post_url, [ "$reply_info_2"=>$formhash, "message"=>$message, ] );
        if ($response->status_line eq '302 Found' || $response->status_line eq '200 OK') {
            print "���ӻ����ɹ�!\n"; 
        }
        print "Successs ! Gotcha ! \n";




        exit;






        ##���Cookie 
        my $url_clear_cookie = $site . '/forum/member.php?action=clearcookies&formhash=' . $formhash ;
        print "Clear Cookie   : $url_clear_cookie \n" ;
        my $res_clear_cookie = $ua->get($url_clear_cookie) ;
        print "Clear Cookie Status: " . $res_clear_cookie->status_line . "\n" ;

        ##�����Ƿ�������
        my $res_cookie_check = $ua->get($url_thread) ;
        print $FILE $res_cookie_check->content ;




        exit;
    } else {
    ##δ���ҵ�
        print "Not have checked info ! \n" ;
    }
    sleep  200;

}






####sub Send_Mail{
####
####use Net::SMTP_auth;
####
####
####my  ($sec,$min,$hour,$mday,$mon,$year) = (localtime)[0..5];
####$mon = $mon + 1;
####
#####smtp�ʼ��������Ͷ˿�
####my $smtpHost = 'smtp.163.com';
####my $smtpPort = '25';
####my $sslPort = '465';
#### 
#####smtp��������֤�û�������(�������½�����ʱ����û���������)
####my $username = 'photouser007@163.com';
####my $passowrd = 'nothing';
#### 
#####�ʼ������Ķ���Ҫȥ�Ķ�,�ʼ�����
####my $from = 'photouser007@163.com';
####my $to   = 'kevin.ljy@live.cn';
####my $subject = "$mon-$mday $hour:$min:$sec Gotcha!";
####
####
#####�����ʼ�header
####my $header = << "MAILHEADER";
####From:$from
####To:$to
####Subject:$subject
####Mime-Version:1.0
####Content-Type:text/plain;charset="UTF-8"
####Content-Trensfer-Encoding:7bit
#### 
####MAILHEADER
#### 
#####�����ʼ�����
####my $message = << "MAILBODY";
####������д�ʼ������ݡ�
####��ã���������$from�Ĳ����ʼ���
####
####MAILBODY
#### 
#####����ʼ��������֣��������ӵ�ʱ��������
####my @helo = split /\@/,$from;
#### 
#####����smtp������������/SSL/TLS���ַ�ʽ��������ʹ�õ�SMTP֧�����ѡ��һ��
#####��2����ʱ����ע���ˣ�����=cut֮��ľ��Ǳ�ע�͵�
#####��ͨ��ʽ��ͨ�Ź��̲�����
####my $smtp = Net::SMTP_auth->new(
####                "$smtpHost:$smtpPort",
####                Hello   => $helo[1],
####                Timeout => 30
####                ) or die("Error:���ӵ�$smtpHostʧ�ܣ�");
####$smtp->auth('LOGIN',$username,$passowrd) or die("Error:��֤ʧ�ܣ�");
#### 
####=cut
#####tls���ܷ�ʽ��ͨ�Ź��̼��ܣ��ʼ����ݰ�ȫ��ʹ��������smtp�˿�
####use Net::SMTP::TLS;
####my $smtp = Net::SMTP::TLS->new(
####                "$smtpHost:$smtpPort",
####                User     => $username,
####                Password => $passowrd,
####                Hello    => $helo[1],
####                Timeout  => 30
####                ) or die "Error:ͨ��TLS���ӵ�$smtpHostʧ�ܣ�";
#### 
#####�����ssl���ܷ�ʽ��ͨ�Ź��̼��ܣ��ʼ����ݰ�ȫ
####use Net::SMTP::SSL;
####my $smtp = Net::SMTP::SSL->new(
####                "$smtpHost:$sslPort",
####                Hello   => $helo[1],
####                Timeout => 30
####                ) or die "Error:ͨ��SSL���ӵ�$smtpHostʧ�ܣ�";
####$smtp->auth($username,$passowrd) or die("Error:��֤ʧ�ܣ�");
####=cut
#### 
#####�����ʼ�
####$smtp->mail($from);
####$smtp->to($to);
####$smtp->data();
####$smtp->datasend($header);
####$smtp->datasend($message);
####$smtp->dataend();
####$smtp->quit();
#### 
####print "Send Mail OK !\n";
####
####}
####
