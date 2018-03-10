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
## 设定选取哪个帐号
    die "没有设定选取帐号!\n " if (@ARGV!=1) ;
    my $id_number = $ARGV[0];
    print "ID number : $id_number \n" ;


##------------------------------------------------------------------
## define variable
    #my $time_stamp       = "2013-8-9" ;
    #my $chongzhika       = "MIDE-595" ;
    #my $Qbi              = "星咲優菜" ;
    #my $seller           = "新片" ;

    my $time_stamp       = "$year-$mon-$mday" ;
    my $chongzhika       = "充值卡" ;
    my $yikachong        = "一卡充" ;
    my $Qbi              = "Q币" ;
    my $wushiyuan        = "50元";
    my $liushiyuan       = "60元";
    my $sanshiyuan       = "30元";
    my $shiyuan          = "10元";
    my $seller           = "出售" ;
    
    my @site_all         = ( 'http://www.sis001.com' ,
	                     'http://68.168.16.158'  ,
                           );

    my @username_all     = ( 'sis086'     ,
                             ''   ,
                           );
    my @password_all     = ( 'yalasi'  ,
                             ''     ,
                           );
    my @message_all      = ( '机会来了，感谢楼主发卡。。。。。。。。。。                               ' ,
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
## Windows32用声音设定
    use Win32;
    use Win32::Sound;
    Win32::Sound::Volume('100%');


##------------------------------------------------------------------
## 打印相关信息
    print "="x75;
    print "\n";
    print "* 程序名     :   论坛检测自动回贴程序\n";
    print "* 检测关键字 :   $seller    $time_stamp\n";
    print "* 检测关键字 :   $chongzhika|$yikachong|$Qbi|$wushiyuan|$liushiyuan|$sanshiyuan|$shiyuan\n";
    print "* 检测网址   :   $url_board\n";
    print "* 用户名     :   $username\n";
    print "* 密码       :   $password\n";
    print "* 回复信息   :   $message\n";
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
#登陆前,取得Login之前的formhash值,用于login
    my $res_login  = $ua->get( $site.'/forum/logging.php?action=login') ;
    my $html_login = $res_login->content;
    die "抓不到formhash" unless $html_login =~ m{formhash=([\d\w]{8})\"?}gi; 
    $formhash_login= $1;
    print "Login前Website  : $site/forum/logging.php?action=login\n" ;
    print "Login前formhash : $formhash_login\n" ;


##------------------------------------------------------------------
#正式登陆
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
#登陆完成后,进入板块,抓取formhash

while(1) {

    my $res_board   = $ua->get($url_board); ##打开指定网页
    my $html_board  = $res_board->content;
#    print "获取版块数据 \n";
    print $FILE $html_board ;
    $html_board =~ m{formhash=([\d\w]{8})\"?}gi; 
    $formhash  = $1;
    print $res_board->status_line ;
    if($res_board->status_line ne '200 OK') {
        print "网络连接有问题~ \n" ;
        sleep 20;
        next ;
    }
    print "Login后Website  : $url_board\n" ;
    print "Login后formhash : $formhash\n" ;
    print "Login后返回值   : " . $res_board->status_line . "\n" ;


##------------------------------------------------------------------

    if($html_board =~ m/$seller.*($chongzhika|$yikachong|$Qbi|$wushiyuan|$liushiyuan|$sanshiyuan|$shiyuan).*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*$time_stamp/) {








        ##邮件提醒
        #Send_Mail();

        ##声音提醒
        for(my $i=0; $i<10; $i++) {
            sleep 0.5;
            Win32::Sound::Play(SystemAsterisk);
        }

        ### For Just Test





    ##已查找到指定信息
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

        ##回复帖子
        my $response=$ua->post( $post_url, [ "$reply_info_2"=>$formhash, "message"=>$message, ] );
        if ($response->status_line eq '302 Found' || $response->status_line eq '200 OK') {
            print "贴子回贴成功!\n"; 
        }
        print "Successs ! Gotcha ! \n";




        exit;






        ##清除Cookie 
        my $url_clear_cookie = $site . '/forum/member.php?action=clearcookies&formhash=' . $formhash ;
        print "Clear Cookie   : $url_clear_cookie \n" ;
        my $res_clear_cookie = $ua->get($url_clear_cookie) ;
        print "Clear Cookie Status: " . $res_clear_cookie->status_line . "\n" ;

        ##测试是否清除完成
        my $res_cookie_check = $ua->get($url_thread) ;
        print $FILE $res_cookie_check->content ;




        exit;
    } else {
    ##未查找到
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
#####smtp邮件服务器和端口
####my $smtpHost = 'smtp.163.com';
####my $smtpPort = '25';
####my $sslPort = '465';
#### 
#####smtp服务器认证用户名密码(就是你登陆邮箱的时候的用户名和密码)
####my $username = 'photouser007@163.com';
####my $passowrd = 'nothing';
#### 
#####邮件来自哪儿，要去哪儿,邮件标题
####my $from = 'photouser007@163.com';
####my $to   = 'kevin.ljy@live.cn';
####my $subject = "$mon-$mday $hour:$min:$sec Gotcha!";
####
####
#####设置邮件header
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
#####设置邮件内容
####my $message = << "MAILBODY";
####在这里写邮件的内容。
####你好，这是来自$from的测试邮件。
####
####MAILBODY
#### 
#####获得邮件域名部分，用于连接的时候表名身份
####my @helo = split /\@/,$from;
#### 
#####连接smtp服务器，明文/SSL/TLS三种方式，根据你使用的SMTP支持情况选择一种
#####后2种暂时被我注释了，两个=cut之间的就是被注释的
#####普通方式，通信过程不加密
####my $smtp = Net::SMTP_auth->new(
####                "$smtpHost:$smtpPort",
####                Hello   => $helo[1],
####                Timeout => 30
####                ) or die("Error:连接到$smtpHost失败！");
####$smtp->auth('LOGIN',$username,$passowrd) or die("Error:认证失败！");
#### 
####=cut
#####tls加密方式，通信过程加密，邮件数据安全，使用正常的smtp端口
####use Net::SMTP::TLS;
####my $smtp = Net::SMTP::TLS->new(
####                "$smtpHost:$smtpPort",
####                User     => $username,
####                Password => $passowrd,
####                Hello    => $helo[1],
####                Timeout  => 30
####                ) or die "Error:通过TLS连接到$smtpHost失败！";
#### 
#####纯粹的ssl加密方式，通信过程加密，邮件数据安全
####use Net::SMTP::SSL;
####my $smtp = Net::SMTP::SSL->new(
####                "$smtpHost:$sslPort",
####                Hello   => $helo[1],
####                Timeout => 30
####                ) or die "Error:通过SSL连接到$smtpHost失败！";
####$smtp->auth($username,$passowrd) or die("Error:认证失败！");
####=cut
#### 
#####发送邮件
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
