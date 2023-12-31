:- use_module(library(date)).
:- use_module(library(odbc)).

% Dados para conex�o com o banco de dados
database('banco_prova2').
username('root').
password('123456').

% Fun��o para conectar ao banco de dados
conectar_banco :-
    odbc_connect('swiprolog', _, [user(root), password('123456'), alias(banco), open(once)]).

% Fun��o para desconectar do banco de dados
desconectar_banco :-
    odbc_disconnect('banco').

% Fun��es para inserir dados no banco de dados
inserir_membro(Nome, Funcao) :-
    odbc_prepare('banco', 'INSERT INTO membro(nome, funcao) VALUES (?, ?)', [varchar, varchar], Statement),
    odbc_execute(Statement, [Nome, Funcao]),
    writeln('Membro inserido com sucesso!').

inserir_habilidade(Nome) :-
    odbc_prepare('banco', 'INSERT INTO habilidade(nome) VALUES (?)', [varchar], Statement),
    odbc_execute(Statement, [Nome]),
    writeln('Habilidade inserida com sucesso!').

atribuir_habilidade_membro(IdMembro, IdHabilidade) :-
    odbc_prepare('banco', 'INSERT INTO membro_habilidade(id_membro, id_habilid) VALUES (?, ?)', [integer, integer], Statement),
    odbc_execute(Statement, [IdMembro, IdHabilidade]),
    writeln('Habilidade atribu�da ao membro com sucesso!').

converter_data(Data, DataConvertida) :-
    atomic_list_concat([Ano, Mes, Dia], '-', Data),
    atom_number(Ano, AnoNum),
    atom_number(Mes, MesNum),
    atom_number(Dia, DiaNum),
    DataConvertida = date(AnoNum, MesNum, DiaNum).

criar_projeto(Nome, Descricao, DataInicio, DataFim, Status, Respons) :-
    converter_data(DataInicio, DataInicioConvertida),
    converter_data(DataFim, DataFimConvertida),
    odbc_prepare('banco', 'INSERT INTO projeto(nome, descric, data_ini, data_term, status, respons) VALUES (?, ?, ?, ?, ?, ?)', [varchar, varchar, date, date, varchar, integer], Statement),
    odbc_execute(Statement, [Nome, Descricao, DataInicioConvertida, DataFimConvertida, Status, Respons]),
    writeln('Projeto criado com sucesso!').

criar_documentacao(Descricao,ProjAssoc, Versao, DataCri, Nome) :-
    converter_data(DataCri, DataCriConvertida),
    odbc_prepare('banco', 'INSERT INTO documento (descric, id_proj, versao, data_cri, nome) VALUES (?, ?, ?, ?, ?)', [varchar, integer, integer, date, varchar], Statement),
    odbc_execute(Statement, [Descricao, ProjAssoc, Versao, DataCriConvertida, Nome]),
    writeln('Documentacao criada com sucesso!').

criar_relatorio(ProjAssoc, DataGen, Tipo) :-
    converter_data(DataGen, DataGenConvertida),
    odbc_prepare('banco', 'INSERT INTO relatorio (id_proj, data_ger, tipo) VALUES (?, ?, ?)', [integer, date, varchar], Statement),
    odbc_execute(Statement, [ProjAssoc, DataGenConvertida, Tipo]),
    writeln('Relat�rio criado com sucesso!').

adicionar_membro_projeto(IdMembro, IdProjeto) :-
    odbc_prepare('banco', 'INSERT INTO membros_projeto(id_membro, id_proj) VALUES (?, ?)', [integer, integer], Statement),
    odbc_execute(Statement, [IdMembro, IdProjeto]),
    writeln('Membro adicionado ao projeto com sucesso!').

adicionar_tarefa_projeto(Descricao, IdProjeto) :-
    odbc_prepare('banco', 'INSERT INTO tarefa(descric, proj_assoc, status) VALUES (?, ?, ?)', [varchar, integer, varchar], Statement),
    odbc_execute(Statement, [Descricao, IdProjeto, 'Pendente']),
    writeln('Tarefa adicionada ao projeto com sucesso!').

concluir_tarefa(IdTarefa) :-
    odbc_prepare('banco', 'UPDATE tarefa SET status = ? WHERE id_taref = ?', [varchar, integer], Statement),
    odbc_execute(Statement, ['Concluida', IdTarefa]),
    writeln('Tarefa conclu�da com sucesso!').

% FunÃ§Ãµes para exibir dados do banco de dados
exibir_membros_projeto(IdProj) :-
    odbc_prepare('banco', 'select distinct membro.nome FROM membros_projeto INNER JOIN membro ON membro.id_membro = membros_projeto.id_membro INNER JOIN projeto ON projeto.id_proj = membros_projeto.id_proj WHERE membros_projeto.id_proj = ?', [integer], Statement, [fetch(fetch)]),
    odbc_execute(Statement, [IdProj]),
    writeln('Membros do Projeto:'),
    exibir_resultado(Statement).

exibir_tarefas_concluidas_projeto(IdProj) :-
    odbc_prepare('banco', 'SELECT descric FROM tarefa WHERE proj_assoc = ? AND status = ?', [integer, varchar], Statement, [fetch(fetch)]),
    odbc_execute(Statement, [IdProj, 'Concluida']),
    writeln('Tarefas Conclu�das do Projeto:'),
    exibir_resultado(Statement).

exibir_membros_com_habilidade(Habilidade) :-
        odbc_prepare('banco', 'select distinct membro.nome FROM membro_habilidade INNER JOIN membro ON membro.id_membro = membro_habilidade.id_membro INNER JOIN habilidade ON habilidade.id_habilid = membro_habilidade.id_habilid WHERE habilidade.nome = ?', [varchar], Statement, [fetch(fetch)]),
    odbc_execute(Statement, [Habilidade]),
    writeln('Membros com a Habilidade:'),
    exibir_resultado(Statement).

exibir_documentos_projeto(IdProj) :-
    odbc_prepare('banco', 'SELECT nome, descric FROM documento WHERE id_proj = ?', [integer], Statement, [fetch(fetch)]),
    odbc_execute(Statement, [IdProj]),
    writeln('Documentos do Projeto:'),
    exibir_resultado(Statement).

exibir_projetos_atrasados() :-
    odbc_prepare('banco', 'SELECT nome FROM projeto WHERE data_term < CURRENT_DATE AND status = "em andamento" ', [], Statement, [fetch(fetch)]),
    odbc_execute(Statement, []),
    writeln('Projetos Atrasados:'),
    exibir_resultado(Statement).

exibir_projetos_em_andamento :-
    odbc_prepare('banco', 'SELECT nome FROM projeto WHERE status = ?', [varchar], Statement, [fetch(fetch)]),
    odbc_execute(Statement, ['em andamento']),
    writeln('Projetos em andamento:'),
    exibir_resultado(Statement).

exibir_membros :-
    odbc_prepare('banco', 'SELECT nome FROM membro', [], Statement, [fetch(fetch)]),
    odbc_execute(Statement, []),
    writeln('Lista de Membros:'),
    exibir_resultado(Statement).

exibir_habilidades :-
    odbc_prepare('banco', 'SELECT nome FROM habilidade', [], Statement, [fetch(fetch)]),
    odbc_execute(Statement, []),
    writeln('Lista de Habilidades:'),
    exibir_resultado(Statement).

exibir_projetos :-
    odbc_prepare('banco', 'SELECT nome FROM projeto', [], Statement, [fetch(fetch)]),
    odbc_execute(Statement, []),
    writeln('Lista de Projetos:'),
    exibir_resultado(Statement).

exibir_tarefas :-
    odbc_prepare('banco', 'SELECT descric FROM tarefa', [], Statement, [fetch(fetch)]),
    odbc_execute(Statement, []),
    writeln('Lista de Tarefas:'),
    exibir_resultado(Statement).


exibir_resultado(Statement) :-
    odbc_fetch(Statement, Row, []),
    (   Row == end_of_file
    ->  true
    ;   Row =.. [_|Args],
        writeln_list(Args),
        exibir_resultado(Statement)
    ).

writeln_list([]).

writeln_list([H|T]) :-
    writeln(H),
    writeln_list(T).

% Função para exibir o menu
menu :-
    writeln('======== Menu ========'),
    writeln('1. Inserir membro'),
    writeln('2. Inserir habilidade'),
    writeln('3. Atribuir habilidade a membro'),
    writeln('4. Criar projeto'),
    writeln('5. Criar relat�rio'),
    writeln('6. Criar documenta�ao'),
    writeln('7. Adicionar membro ao projeto'),
    writeln('8. Adicionar tarefa ao projeto'),
    writeln('9. Concluir tarefa'),
    writeln('10. Exibir todos os membros'),
    writeln('11. Exibir todas as habilidades'),
    writeln('12. Exibir todos os projetos'),
    writeln('13. Exibir todas as tarefas'),
    writeln('14. Exibir projetos em andamento no momento'),
    writeln('15. Exibir membros de um projeto'),
    writeln('16. Exibir tarefas conclu�das de um projeto'),
    writeln('17. Exibir membros com uma habilidade espec�fica'),
    writeln('18. Exibir documentos de um projeto'),
    writeln('19. Exibir projetos atrasados'),
    writeln('20. Sair'),
    writeln('======================='),
    read(Opcao),
    executar_opcao(Opcao).

% Função para executar a op��o selecionada
executar_opcao(1) :-
    % Inserir membro
    writeln('Informe o nome do membro:'),
    read(Nome),
    writeln('Informe a fun��o do membro:'),
    read(Funcao),
    inserir_membro(Nome, Funcao),
    menu.

executar_opcao(2) :-
    % Inserir habilidade
    writeln('Informe o nome da habilidade:'),
    read(Nome),
    inserir_habilidade(Nome),
    menu.

executar_opcao(3) :-
    % Atribuir habilidade a membro
    writeln('Informe o ID do membro:'),
    read(IdMembro),
    writeln('Informe o ID da habilidade:'),
    read(IdHabilidade),
    atribuir_habilidade_membro(IdMembro, IdHabilidade),
    menu.

executar_opcao(4) :-
    % Criar projeto
    writeln('Informe o nome do projeto:'),
    read(Nome),
    writeln('Informe a descri��o do projeto:'),
    read(Descricao),
    writeln('Informe a data de in�cio do projeto (formato: YYYY-MM-DD):'),
    read(DataInicio),
    writeln('Informe a data de fim do projeto (formato: YYYY-MM-DD):'),
    read(DataFim),
    writeln('Informe o status do projeto (em andamento, conclu�do, cancelado):'),
    read(Status),
    writeln('Informe o respons�vel do projeto:'),
    read(Respons),
    criar_projeto(Nome, Descricao, DataInicio, DataFim, Status, Respons),
    menu.

executar_opcao(5) :-
    % Criar relatorio
    writeln('Informe o projeto associado :'),
    read(ProjAssoc),
    writeln('Informe a data de gera��o (formato: YYYY-MM-DD):'),
    read(DataGen),
    writeln('Informe o tipo de relat�rio:'),
    read(Tipo),
    criar_relatorio(ProjAssoc, DataGen,Tipo),
    menu.


executar_opcao(6) :-
    % Criar documentação
    writeln('Informe a descri��o da documentacao:'),
    read(Descricao),
    writeln('Informe o projeto associado:'),
    read(ProjAssoc),
    writeln('Informe a versao:'),
    read(Versao),
    writeln('Informe a data de criacao:'),
    read(DataCri),
    writeln('Informe o nome do documento:'),
    read(Nome),
    criar_documentacao(Descricao, ProjAssoc, Versao, DataCri, Nome),
    menu.

executar_opcao(7) :-
    % Adicionar membro ao projeto
    writeln('Informe o ID do membro:'),
    read(IdMembro),
    writeln('Informe o ID do projeto:'),
    read(IdProjeto),
    adicionar_membro_projeto(IdMembro, IdProjeto),
    menu.

executar_opcao(8) :-
    % Adicionar tarefa ao projeto
    writeln('Informe a descricao da tarefa:'),
    read(Descricao),
    writeln('Informe o ID do projeto:'),
    read(IdProjeto),
    adicionar_tarefa_projeto(Descricao, IdProjeto),
    menu.

executar_opcao(9) :-
    % Concluir tarefa
    writeln('Informe o ID da tarefa:'),
    read(IdTarefa),
    concluir_tarefa(IdTarefa),
    menu.

executar_opcao(10) :-
    % Exibir todos os membros
    exibir_membros,
    menu.

executar_opcao(11) :-
    % Exibir todas as habilidades
    exibir_habilidades,
    menu.

executar_opcao(12) :-
    % Exibir todos os projetos
    exibir_projetos,
    menu.

executar_opcao(13) :-
    % Exibir todas as tarefas
    exibir_tarefas,
    menu.

executar_opcao(14) :-
    % Exibir projetos em andamento
    exibir_projetos_em_andamento,
    menu.

executar_opcao(15) :-
    % Exibir membros de um projeto
    writeln('Informe o ID do projeto:'),
    read(IdProj),
    exibir_membros_projeto(IdProj),
    menu.

executar_opcao(16) :-
    % Exibir tarefas conclu�das de um projeto
    writeln('Informe o ID do projeto:'),
    read(IdProj),
    exibir_tarefas_concluidas_projeto(IdProj),
    menu.

executar_opcao(17) :-
    % Exibir membros com uma habilidade especí­fica
    writeln('Informe a habilidade:'),
    read(Habilidade),
    exibir_membros_com_habilidade(Habilidade),
    menu.

executar_opcao(18) :-
    % Exibir documentos de um projeto
    writeln('Informe o ID do projeto:'),
    read(IdProj),
    exibir_documentos_projeto(IdProj),
    menu.

executar_opcao(19) :-
    % Exibir projetos atrasados
    exibir_projetos_atrasados(),
    menu.

executar_opcao(20) :-
    % Sair
    desconectar_banco,
    writeln('Encerrando...').

executar_opcao(_) :-
    % Opção inválida
    writeln('Opcao inv�lida!'),
    menu.

% Função principal
:- initialization main.

main :-
    conectar_banco(Banco),
    menu(Banco).
