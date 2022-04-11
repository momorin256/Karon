# Karon: CLI Password Manager written with Ruby

Karon is a password manager works on a terminal.

# Help

```sh
$ ./karon.rb
list [-f <db-file>]
        Show list of all records.

select <index> [-f <db-file>]
        Select record by the index and print the password.

add <title> <user> [-p <password>] [-f <db-file>]
        Add a new record.

remove <index> [-f <db-file>]
        Remove a record specified by the index.

change <new-key> [-f <db-file>]
        Change the secret key.
```

# Usage Sample

```sh
$ ./karon.rb add 'sample title' 'sample user' -f sample.json
Input key: 
Input password: 

$ ./karon.rb add '2nd title' '2nd user' -f sample.json
Input key: 
Input password: 

$ ./karon.rb list -f sample.json
(0) sample title | sample user |
(1)  2nd title   |  2nd user   |

$ ./karon.rb select 0 -f sample.json
Input key: 
sample password
```

If you don't specify `-f` option, db file is created in `~/.karon/db.json`.

# Test

```sh
$ ruby test/record_test.rb
Run options: --seed 26618

# Running:

...

Finished in 0.003779s, 793.9165 runs/s, 1323.1941 assertions/s.

3 runs, 5 assertions, 0 failures, 0 errors, 0 skips
```

# DB file

Karon's database is a single json file. Password is encrypted with AES256, and encoded with Base64.

```sh
$ cat test/test.json | jq .
[
  {
    "title": "Title01",
    "user": "user-name",
    "password": "4wGKj5A74RpAm89LxkcY7hG2+/aXu7RB\n"
  },
  {
    "title": "Second Title",
    "user": "2nd user name",
    "password": "0oOPU9eO6TtrnuHjut4/hijH4rkJh1Qa\n"
  },
  {
    "title": "(a[0]/2)+($e.#?)~!",
    "user": "%%",
    "password": "bWYhzkSiTmc5Lik+PLHFQST+LN2YXUKT\n"
  }
]
```
