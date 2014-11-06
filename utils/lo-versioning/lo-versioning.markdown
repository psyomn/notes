% Using LibreOffice's Versioning Features (For a Better Tomorrow)
% Simon Symeonidis
% _Wed Dec  4 22:44:56 EST 2013_
# Using LibreOffice's Versioning

This is a very small document that shows the reader how to use versioning in 
libreoffice. It also highlights briefly the benefits of using such technology.

## Documents, Documents Everywhere

If you're in an environment where many documents need to be edited frequently,
and shared among people, then there could be a lot of trouble when trying to 
figure out if some people edited the same file on different machines, with 
conflicting changes. For example, if a document has three parts 'A', 'B', and
'C', and 2 users acquire a copy of this document, and both coincidentally
perform changes on parts 'C', and 'B', the document is in a conflicting state
and more work needs to be done in order to merge the work. 

This could be avoided by assigning certain sections to different assignees. It
is not always the case however, that the document may be structured in such a 
convenient manner to make parallel work possible. 

Managing document work on different machines at the same time would also be
possible using source management tools such as git or svn, provided that all 
the documentation was done in text format, using markup such as LaTeX or even
markdown. But this assumes that everyone on the team would be familiar with 
these tools as opposed to using an office suite.

This is where libreoffice's versioning can be used, along with the comparing 
documents functionality. 

## Versioning

On a traditional setting, in order to be able to look back in time on a
particular document, the course of action would be to copy backups of the file
along the timeline of the project. This can be tedious and erroneous. 

A feature in LibreOffice allows us to save snapshots of a document and view
older versions and track back. It also has a functionality where you can view
the changes done between two versions. 

Take a look at Figure \ref{fig:initial} - that is our initial document. We want
to save a snapshot of this state of the document. We can do this by clicking on 
the menu item _file_, and _versions_. You can observe this in Figure
\ref{fig:menuversions}. That will open up a dialog that we access, and click on
`Save New Version`. Click on that. A dialog will open where you can enter a
small description about the work done on the current version of the document.
Press 'Ok'. Figure \ref{fig:versioningdialog} shows the versioning dialog with a
small comment. The results of saving a snapshot are shown in Figure
\ref{fig:versioning-list}.

![Initial Document\label{fig:initial}](fig/initial.png)

![Versioning Menu Item\label{fig:menuversions}](fig/versioning.png)

![Versioning Dialog\label{fig:versioningdialog}](fig/versioning-dialog.png)

![Versioning List\label{fig:versioning-list}](fig/version-list.png)

Now, to continue on with the example, we add a lorem ipsum paragraph to the 
document. We see the addition in Figure \ref{fig:lorem}. We repeat the previous
steps, and save the new state of the document. We can see this in figure
\ref{fig:loremnew}.

![Lorem Ipsum\label{fig:lorem}](fig/lorem.png)

![Lorem Ipsum\label{fig:loremnew}](fig/loremnew.png)

# Checking for Differences

We can now check for differences between documents. To do this, we need to 
click on one of the available versions in order to select it, and then click on
the button labeled `Compare`. This will show the differences between the
current version of the document, and the selected version in the dialog. The
way the changes are shown are by coloring the changed elements to dark yellow.
Additionally we are given a dialog where we can accept or reject previous
transactions. We can see this in Figure \ref{fig:comparison}.

![Changes \label{fig:comparison}](fig/changes.png)

# Comparing Two Documents

Another feature that may be used, but is not as powerful, is comparing two
separate documents, similar to the way we saw in versioning. You need two 
documents, which have undergone change. Then, you simply click on the `Edit`
menu item, and the on `Compare Documents...`.

This opens a similar dialog to the one of versioning. This is observed in
Figure \ref{fig:compare}.

![Comparing Separate Documents\ref{fig:compare}](fig/compare.png)

