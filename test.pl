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
my $keyword = "uid=888\">�춥����" ;

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

#smtp�ʼ��������Ͷ˿�
my $smtpHost = 'smtp.163.com';
my $smtpPort = '25';
my $sslPort = '465';
 
#smtp��������֤�û�������(�������½�����ʱ����û���������)
my $username = 'photouser007@163.com';
my $passowrd = 'nothing';
 
#�ʼ������Ķ���Ҫȥ�Ķ�,�ʼ�����
my $from = 'photouser007@163.com';
my $to   = 'kevin.ljy@139.com';
my $subject = "$mon-$mday $hour:$min:$sec Gotcha!";


#�����ʼ�header
my $header = << "MAILHEADER";
From:$from
To:$to
Subject:$subject
Mime-Version:1.0
Content-Type:text/plain;charset="UTF-8"
Content-Trensfer-Encoding:7bit
 
MAILHEADER
 
#�����ʼ�����
my $message = << "MAILBODY";
������д�ʼ������ݡ�
��ã���������$from�Ĳ����ʼ���

MAILBODY
 
#����ʼ��������֣��������ӵ�ʱ��������
my @helo = split /\@/,$from;
 
#����smtp������������/SSL/TLS���ַ�ʽ��������ʹ�õ�SMTP֧�����ѡ��һ��
#��2����ʱ����ע���ˣ�����=cut֮��ľ��Ǳ�ע�͵�
#��ͨ��ʽ��ͨ�Ź��̲�����
my $smtp = Net::SMTP_auth->new(
                "$smtpHost:$smtpPort",
                Hello   => $helo[1],
                Timeout => 30
                ) or die("Error:���ӵ�$smtpHostʧ�ܣ�");
$smtp->auth('LOGIN',$username,$passowrd) or die("Error:��֤ʧ�ܣ�");
 
=cut
#tls���ܷ�ʽ��ͨ�Ź��̼��ܣ��ʼ����ݰ�ȫ��ʹ��������smtp�˿�
use Net::SMTP::TLS;
my $smtp = Net::SMTP::TLS->new(
                "$smtpHost:$smtpPort",
                User     => $username,
                Password => $passowrd,
                Hello    => $helo[1],
                Timeout  => 30
                ) or die "Error:ͨ��TLS���ӵ�$smtpHostʧ�ܣ�";
 
#�����ssl���ܷ�ʽ��ͨ�Ź��̼��ܣ��ʼ����ݰ�ȫ
use Net::SMTP::SSL;
my $smtp = Net::SMTP::SSL->new(
                "$smtpHost:$sslPort",
                Hello   => $helo[1],
                Timeout => 30
                ) or die "Error:ͨ��SSL���ӵ�$smtpHostʧ�ܣ�";
$smtp->auth($username,$passowrd) or die("Error:��֤ʧ�ܣ�");
=cut
 
#�����ʼ�
$smtp->mail($from);
$smtp->to($to);
$smtp->data();
$smtp->datasend($header);
$smtp->datasend($message);
$smtp->dataend();
$smtp->quit();
 
print "Send Mail OK !\n";

}
