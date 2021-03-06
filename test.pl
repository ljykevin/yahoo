#!/usr/bin/perl -w

##------------------------------------------------------------------
## get date/time
use Time::Local; 
my  ($sec,$min,$hour,$mday,$mon,$year) = (localtime)[0..5];
$year = $year + 1900;
$mon  = $mon  + 1;




##------------------------------------------------------------------
## define variable
my $time_stamp = "$year-$mon-$mday" ;
print "$time_stamp \n" ;
my $keyword = "uid=888\">红顶商人" ;

#my $time_stamp = "sis086" ;
#print "$time_stamp \n" ;
#my $keyword = "$year-$mon-$mday" ;


##------------------------------------------------------------------
## search in html
use Win32;
use Win32::Sound;

Win32::Sound::Volume('100%');
my $flag = 0;



while(1) {

    if(-e "C:\\Users\\Kevin\\Documents\\1.txt") {
        open $FILE,"< C:\\Users\\Kevin\\Documents\\1.txt";
    
        while(<$FILE>){
    
            if($flag == 1) {
                if(/$time_stamp/) {
                    print ;
                    my  ($sec,$min,$hour,$mday,$mon,$year) = (localtime)[0..5];
                    print "Gotcha ! @ $hour:$min:$sec \n" ;
                    Send_Mail();
                    while(1) {
                        Win32::Sound::Play(SystemAsterisk);
                        sleep 0.5;
                    }
                }
                else  {$flag = 0} ;
            }
    
            $flag=1 if(/$keyword/) ;
        }
    
        close $FILE;
        unlink "C:\\Users\\Kevin\\Documents\\1.txt";
    }

    sleep 3;
}




sub Send_Mail{

use Net::SMTP_auth;


my  ($sec,$min,$hour,$mday,$mon,$year) = (localtime)[0..5];
$mon = $mon + 1;

#smtp邮件服务器和端口
my $smtpHost = 'smtp.163.com';
my $smtpPort = '25';
my $sslPort = '465';
 
#smtp服务器认证用户名密码(就是你登陆邮箱的时候的用户名和密码)
my $username = 'photouser007@163.com';
my $passowrd = 'nothing';
 
#邮件来自哪儿，要去哪儿,邮件标题
my $from = 'photouser007@163.com';
my $to   = 'kevin.ljy@139.com';
my $subject = "$mon-$mday $hour:$min:$sec Gotcha!";


#设置邮件header
my $header = << "MAILHEADER";
From:$from
To:$to
Subject:$subject
Mime-Version:1.0
Content-Type:text/plain;charset="UTF-8"
Content-Trensfer-Encoding:7bit
 
MAILHEADER
 
#设置邮件内容
my $message = << "MAILBODY";
在这里写邮件的内容。
你好，这是来自$from的测试邮件。

MAILBODY
 
#获得邮件域名部分，用于连接的时候表名身份
my @helo = split /\@/,$from;
 
#连接smtp服务器，明文/SSL/TLS三种方式，根据你使用的SMTP支持情况选择一种
#后2种暂时被我注释了，两个=cut之间的就是被注释的
#普通方式，通信过程不加密
my $smtp = Net::SMTP_auth->new(
                "$smtpHost:$smtpPort",
                Hello   => $helo[1],
                Timeout => 30
                ) or die("Error:连接到$smtpHost失败！");
$smtp->auth('LOGIN',$username,$passowrd) or die("Error:认证失败！");
 
=cut
#tls加密方式，通信过程加密，邮件数据安全，使用正常的smtp端口
use Net::SMTP::TLS;
my $smtp = Net::SMTP::TLS->new(
                "$smtpHost:$smtpPort",
                User     => $username,
                Password => $passowrd,
                Hello    => $helo[1],
                Timeout  => 30
                ) or die "Error:通过TLS连接到$smtpHost失败！";
 
#纯粹的ssl加密方式，通信过程加密，邮件数据安全
use Net::SMTP::SSL;
my $smtp = Net::SMTP::SSL->new(
                "$smtpHost:$sslPort",
                Hello   => $helo[1],
                Timeout => 30
                ) or die "Error:通过SSL连接到$smtpHost失败！";
$smtp->auth($username,$passowrd) or die("Error:认证失败！");
=cut
 
#发送邮件
$smtp->mail($from);
$smtp->to($to);
$smtp->data();
$smtp->datasend($header);
$smtp->datasend($message);
$smtp->dataend();
$smtp->quit();
 
print "Send Mail OK !\n";

}
