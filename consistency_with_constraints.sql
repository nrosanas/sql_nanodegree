ALTER TABLE authors ADD PRIMARY KEY (id);
ALTER TABLE authors ADD UNIQUE (email_address);

ALTER TABLE books ADD PRIMARY KEY (id);
ALTER TABLE books ADD UNIQUE (isbn);

ALTER TABLE books_authors ADD PRIMARY KEY (book_id, author_id);
ALTER TABLE books_authors ADD UNIQUE (book_id, contribution_rank);

-- exercici FK
ALTER TABLE employees ADD FOREIGN KEY (manager_id) REFERENCES employees (id) ON DELETE SET NULL;

ALTER TABLE employee_projects ADD FOREIGN KEY (employee_id) REFERENCES employees (id);
ALTER TABLE employee_projects ADD FOREIGN KEY (project_id) REFERENCES projects (id) ON DELETE CASCADE;