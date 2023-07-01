
% Dados para conexÃ£o com o banco de dados
database('banco_prova2').
username('root').
password('123456').

% FunÃ§Ã£o para conectar ao banco de dados
conectar_banco :-
    odbc_connect('swiprolog', _, [user(root), password('123456'), alias(banco), open(once)]).

% FunÃ§Ã£o para desconectar do banco de dados
desconectar_banco :-
    odbc_disconnect('banco').

% Funções para inserir dados no banco de dados
inserir_membro(Nome, Funcao) :-
    odbc_prepare('banco', 'INSERT INTO membro(nome, funcao) VALUES (?, ?)', [varchar, varchar], Statement),
    odbc_execute(Statement, [Nome, Funcao]),
    writeln('Membro inserido com sucesso!').

inserir_habilidade(Nome) :-
    odbc_prepare('banco', 'INSERT INTO habilidade(nome) VALUES (?)', [varchar], Statement),
    odbc_execute(Statement, [Nome]),
    writeln('Habilidade inserida com sucesso!').

atribuir_habilidade_membro(IdMembro, IdHabilidade) :-
    odbc_prepare('banco', 'INSERT INTO membro_habilidade(id_membro, id_habilidade) VALUES (?, ?)', [integer, integer], Statement),
    odbc_execute(Statement, [IdMembro, IdHabilidade]),
    writeln('Habilidade atribuída ao membro com sucesso!').

criar_projeto(Nome, Descricao, DataInicio, DataFim) :-
    odbc_prepare('banco', 'INSERT INTO projeto(nome, descric, data_ini, data_term) VALUES (?, ?, ?, ?)', [varchar, varchar, varchar, varchar], Statement),
    odbc_execute(Statement, [Nome, Descricao, DataInicio, DataFim]),
    writeln('Projeto criado com sucesso!').

adicionar_membro_projeto(IdMembro, IdProjeto, Banco) :-
    odbc_prepare(Banco, 'INSERT INTO membros_projeto(id_membro, id_projeto) VALUES (?, ?)', [integer, integer], Statement),
    odbc_execute(Statement, [IdMembro, IdProjeto]),
    writeln('Membro adicionado ao projeto com sucesso!').

adicionar_tarefa_projeto(Descricao, IdProjeto, Banco) :-
    odbc_prepare(Banco, 'INSERT INTO tarefa(descricao, id_projeto, status) VALUES (?, ?, ?)', [varchar, integer, varchar], Statement),
    odbc_execute(Statement, [Descricao, IdProjeto, 'Pendente']),
    writeln('Tarefa adicionada ao projeto com sucesso!').

concluir_tarefa(IdTarefa, Banco) :-
    odbc_prepare(Banco, 'UPDATE tarefa SET status = ? WHERE id = ?', [varchar, integer], Statement),
    odbc_execute(Statement, ['Concluída', IdTarefa]),
    writeln('Tarefa concluída com sucesso!').

% Funções para exibir dados do banco de dados
exibir_membros_projeto(IdProj, Banco) :-
    odbc_prepare(Banco, 'SELECT m.nome, m.funcao FROM membro m INNER JOIN membros_projetos mp ON m.id = mp.id_membro WHERE mp.id_projeto = ?', [integer], Statement),
    odbc_execute(Statement, [IdProj]),
    writeln('Membros do Projeto:'),
    exibir_resultado(Statement).

exibir_tarefas_concluidas_projeto(IdProj, Banco) :-
    odbc_prepare(Banco, 'SELECT descricao FROM tarefa WHERE id_projeto = ? AND status = ?', [integer, varchar], Statement),
    odbc_execute(Statement, [IdProj, 'Concluída']),
    writeln('Tarefas Concluídas do Projeto:'),
    exibir_resultado(Statement).

exibir_membros_com_habilidade(Habilidade, Banco) :-
    odbc_prepare(Banco, 'SELECT m.nome FROM membro m INNER JOIN membros_habilidades mh ON m.id = mh.id_membro INNER JOIN habilidades h ON mh.id_habilidade = h.id WHERE h.nome = ?', [varchar], Statement),
    odbc_execute(Statement, [Habilidade]),
    writeln('Membros com a Habilidade:'),
    exibir_resultado(Statement).

exibir_documentos_projeto(IdProj, Banco) :-
    odbc_prepare(Banco, 'SELECT nome, descricao FROM documento WHERE id_projeto = ?', [integer], Statement),
    odbc_execute(Statement, [IdProj]),
    writeln('Documentos do Projeto:'),
    exibir_resultado(Statement).

exibir_projetos_atrasados(Banco) :-
    odbc_prepare(Banco, 'SELECT nome FROM projeto WHERE data_fim < CURRENT_DATE', [], Statement),
    odbc_execute(Statement, []),
    writeln('Projetos Atrasados:'),
    exibir_resultado(Statement).

exibir_resultado(Statement) :-
    odbc_fetch(Statement, Row),
    exibir_row(Row),
    exibir_resultado(Statement).

exibir_resultado(_) :-
    nl.

exibir_row(Row) :-
    odbc_column_table(Row, Table),
    exibir_columns(Row, Table).

exibir_columns(_, []).
exibir_columns(Row, [Col | Cols]) :-
    odbc_column(Row, Col, Value),
    write(Col), write(': '), writeln(Value),
    exibir_columns(Row, Cols).

% Função para exibir o menu
menu :-
    writeln('======== Menu ========'),
    writeln('1. Inserir membro'),
    writeln('2. Inserir habilidade'),
    writeln('3. Atribuir habilidade a membro'),
    writeln('4. Criar projeto'),
    writeln('5. Adicionar membro ao projeto'),
    writeln('6. Adicionar tarefa ao projeto'),
    writeln('7. Concluir tarefa'),
    writeln('8. Exibir membros de um projeto'),
    writeln('9. Exibir tarefas concluídas de um projeto'),
    writeln('10. Exibir membros com uma habilidade específica'),
    writeln('11. Exibir documentos de um projeto'),
    writeln('12. Exibir projetos atrasados'),
    writeln('13. Sair'),
    writeln('======================='),
    read(Opcao),
    executar_opcao(Opcao).

% Função para executar a opção selecionada
executar_opcao(1) :-
    % Inserir membro
    writeln('Informe o nome do membro:'),
    read(Nome),
    writeln('Informe a função do membro:'),
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
    writeln('Informe a descrição do projeto:'),
    read(Descricao),
    writeln('Informe a data de início do projeto (formato: YYYY-MM-DD):'),
    read(DataInicio),
    writeln('Informe a data de fim do projeto (formato: YYYY-MM-DD):'),
    read(DataFim),
    criar_projeto(Nome, Descricao, DataInicio, DataFim),
    menu.

executar_opcao(5, Banco) :-
    % Adicionar membro ao projeto
    writeln('Informe o ID do membro:'),
    read(IdMembro),
    writeln('Informe o ID do projeto:'),
    read(IdProjeto),
    adicionar_membro_projeto(IdMembro, IdProjeto, Banco),
    menu(Banco).

executar_opcao(6, Banco) :-
    % Adicionar tarefa ao projeto
    writeln('Informe a descrição da tarefa:'),
    read(Descricao),
    writeln('Informe o ID do projeto:'),
    read(IdProjeto),
    adicionar_tarefa_projeto(Descricao, IdProjeto, Banco),
    menu(Banco).

executar_opcao(7, Banco) :-
    % Concluir tarefa
    writeln('Informe o ID da tarefa:'),
    read(IdTarefa),
    concluir_tarefa(IdTarefa, Banco),
    menu(Banco).

executar_opcao(8, Banco) :-
    % Exibir membros de um projeto
    writeln('Informe o ID do projeto:'),
    read(IdProj),
    exibir_membros_projeto(IdProj, Banco),
    menu(Banco).

executar_opcao(9, Banco) :-
    % Exibir tarefas concluídas de um projeto
    writeln('Informe o ID do projeto:'),
    read(IdProj),
    exibir_tarefas_concluidas_projeto(IdProj, Banco),
    menu(Banco).

executar_opcao(10, Banco) :-
    % Exibir membros com uma habilidade específica
    writeln('Informe a habilidade:'),
    read(Habilidade),
    exibir_membros_com_habilidade(Habilidade, Banco),
    menu(Banco).

executar_opcao(11, Banco) :-
    % Exibir documentos de um projeto
    writeln('Informe o ID do projeto:'),
    read(IdProj),
    exibir_documentos_projeto(IdProj, Banco),
    menu(Banco).

executar_opcao(12, Banco) :-
    % Exibir projetos atrasados
    exibir_projetos_atrasados(Banco),
    menu(Banco).

executar_opcao(13, Banco) :-
    % Sair
    desconectar_banco(Banco),
    writeln('Encerrando...').

executar_opcao(_, Banco) :-
    % Opção inválida
    writeln('Opção inválida!'),
    menu(Banco).

% Função principal
:- initialization main.

main :-
    conectar_banco(Banco),
    menu(Banco).

