<?php
class EmailModel extends Model {
    
    function __construct() {
        parent::__construct();
        $this->load->library('email');
    }
    
   function enviarEmailBoasVindas($email_peoplegrid,$senha_peoplegrid,$EducadorNome,$educadorEmail){
        $config['protocol']    = 'smtp';
        $config['smtp_host']    = 'ssl://smtp.gmail.com';
        $config['smtp_port']    = '465';
        $config['smtp_timeout'] = '30';
        $config['smtp_user']    = $email_peoplegrid;
        $config['smtp_pass']    = $senha_peoplegrid;
        $config['charset']    = 'utf-8';
        $config['newline']    = "\r\n";
        $config['mailtype'] = 'html'; // or html
        $config['validation'] = TRUE; // bool whether to validate email or not      

        $this->email->initialize($config);

        $this->email->from($email_peoplegrid, 'PeopleGrid');
        $this->email->to($educadorEmail); 

        $this->email->subject('peoplegrid - Bem Vindo Colaborador!');
        $this->email->message(
                "<html>
                    <body>
                        <p>
                            Bem vindo <b>$EducadorNome!</b>, ao Sistema de Participação Popular <b>PeopleGrid</b>
                        </p>
                        <p>
                            Estamos muito felizes por você ter se tornado mais um colaborador para o projeto.
                        </p>
                        <p>
                            Acesse o sistema <a href=\"".BASE_URL."\">PeopleGrid</a>.
                        </p>
                    </body>
                </html>");
        $this->email->send();
        log_message('ERROR', $this->email->print_debugger());
    }
    
    function notificaAdministradorDoSistema($email_peoplegrid,$senha_peoplegrid,$email_administrador,$titulo,$conteudo){
        $config['protocol']    = 'smtp';
        $config['smtp_host']    = 'ssl://smtp.gmail.com';
        $config['smtp_port']    = '465';
        $config['smtp_timeout'] = '30';
        $config['smtp_user']    = $email_peoplegrid;
        $config['smtp_pass']    = $senha_peoplegrid;
        $config['charset']    = 'utf-8';
        $config['newline']    = "\r\n";
        $config['mailtype'] = 'text'; // or html
        $config['validation'] = TRUE; // bool whether to validate email or not      

        $this->email->initialize($config);

        $this->email->from($email_peoplegrid, "PeopleGrid");
        $this->email->to($email_administrador); 

        $this->email->subject($titulo);
        $this->email->message($conteudo);  

        $this->email->send();
        log_message('INFO', $this->email->print_debugger());
    }
    
    function enviarLiberacaoDeAcesso($email_peoplegrid,$senha_peoplegrid,$PessoaNome,$educadorEmail){
        $config['protocol']    = 'smtp';
        $config['smtp_host']    = 'ssl://smtp.gmail.com';
        $config['smtp_port']    = '465';
        $config['smtp_timeout'] = '30';
        $config['smtp_user']    = $email_peoplegrid;
        $config['smtp_pass']    = $senha_peoplegrid;
        $config['charset']    = 'utf-8';
        $config['newline']    = "\r\n";
        $config['mailtype'] = 'html'; // or html
        $config['validation'] = TRUE; // bool whether to validate email or not      

        $this->email->initialize($config);

        $this->email->from($email_peoplegrid,"PeopleGrid");
        $this->email->to($educadorEmail); 

        $this->email->subject('peoplegrid - Liberação de Conta');
        $this->email->message(
                "<html>
                    <body>
                        <img src=\"https://cdn1.iconfinder.com/data/icons/windows-8-metro-style/64/info.png\">
                        <p>
                            Olá <b>$PessoaNome</b>!\n
                                seu pedido de <b>Acesso ao PeopleGrid</b> acaba de ser liberado.\n
                        </p>
                        <p>
                            Acesse o sistema <a href=\"".BASE_URL."\">PeopleGrid</a>.
                        </p>
                    </body>
                </html>
                    ");  

        $this->email->send();
        log_message('INFO', $this->email->print_debugger());
    }
    
    function enviarNovaSenha($email_peoplegrid,$senha_peoplegrid,$educador_nome,$educador_email,$nova_senha){
        
        $config['protocol']    = 'smtp';
        $config['smtp_host']    = 'ssl://smtp.gmail.com';
        $config['smtp_port']    = '465';
        $config['smtp_timeout'] = '30';
        $config['smtp_user']    = $email_peoplegrid;
        $config['smtp_pass']    = $senha_peoplegrid;
        $config['charset']    = 'utf-8';
        $config['newline']    = "\r\n";
        $config['mailtype'] = 'html'; // or html
        $config['validation'] = TRUE; // bool whether to validate email or not      

        $this->email->initialize($config);

        $this->email->from($email_peoplegrid, "PeopleGrid");
        $this->email->to($educador_email); 

        $this->email->subject('peoplegrid - Nova Senha requisitada');
        $this->email->message(
                "<html>
                    <body>
                        <img src=\"https://cdn1.iconfinder.com/data/icons/windows-8-metro-style/64/info.png\">
                        <p>
                            Olá <b>$educador_nome</b>!<br>
                                Uma nova senha foi gerada para você. <br>Para acessar a sua conta no peoplegrid você deve usar a senha abaixo:<br>Senha:<b> $nova_senha</b>\n\n
                        </p>
                        <p>
                            Obs.: Após acessar sua conta você poderá modificá-la a qualquer momento;
                        </p>
                        <p>
                            Acesse o sistema <a href=\"".BASE_URL."\">PeopleGrid</a>.
                        </p>
                    </body>
                </html>
                    ");  

        $this->email->send();
        log_message('INFO', $this->email->print_debugger());
    }
}
?>