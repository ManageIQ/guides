### Setting up Project in RubyMine

File -> New Project
Select to Add "Rails application" on the left, then in Location point to the location where you have source code checked out for example "/home/hkataria/dev/manageiq"
![alt tag](/images/rubymine_create_project.png)


Select Ruby SDK version to point to correct Ruby version, that should auto select correct Rails version for you.
Press "Create" button on the screen. This will prompt you about the directory selected in Location field not being empty, go-ahead and press "Yes"

![alt tag](/images/rubymine_create_project_verify.png)


### To setup Git
Once project is created, you will be prompted to add git root in order to hook up with git for VCS operations.
![alt tag](/images/rubymine_git_prompt.png)


Click on configure link in the pop up above, once presented with Version Control settings everything should already be populated for , press “Ok” there
![alt tag](/images/rubymine_git_setup.png)

### Setting up Database tools
You can setup Database tool to point to your PG database which makes it easier to view table records in RubyMine itself.
Go to View menu -> Toolbar windows, select Database. Then go to Database tool window, and press"New" button to add database configuration. Select PostgreSQL as Data Source

From Run menu, you can run the newly created project in regular or debug mode, when running it debug mode,
it might prompt you about missing "ruby-debug-ide" gem and will give you an option to install that, say yes Rubymine will install missing gem for you,
once gem is installed you should be good to run the project in Rubymine.
![alt tag](/images/rubymine_data_source_setup.png)

### Setting up default Ruby version for a current Project
This helps in running server as well as running RSPEC tests from within Rubymine, when running spec tests or a server it picks up correct version of gems.
![alt tag](/images/rubymine_sdk_setup.png)
Select the correct version of ruby you want to use then press green arrow in the middle of the panels to make it default for current project,
after applying changes you might need to restart RubyMine to pick up the changes. Once RubyMine is restarted you should be able to right click on the spec test name
and choose Run to run spec test or you can simple right click inside a block and choose run to just run a single block.
