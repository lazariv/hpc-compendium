# JupyterHub for Teaching

On this page we want to introduce to you some useful features if you
want to use JupyterHub for teaching.

<span class="twiki-macro RED"></span> **PLEASE UNDERSTAND:** <span
class="twiki-macro ENDCOLOR"></span> JupyterHub uses compute resources
from the HPC system Taurus. Please be aware of the following notes:

-   The HPC system operates at a lower availability level than your
    usual Enterprise Cloud VM. There can always be downtimes, e.g. of
    the file systems or the batch system.
-   Scheduled downtimes are announced by email. Please plan your courses
    accordingly.
-   Access to HPC resources is handled through projects. See your course
    as a project. Projects need to be registered beforehand (more info
    on the page [Access](Compendium.Access)).
-   Don't forget to [add your
    users](ProjectManagement#manage_project_members_40dis_45_47enable_41)
    (eg. students or tutors) to your project.
-   It might be a good idea to [request a
    reservation](Slurm#Reservations) of part of the compute resources
    for your project/course to avoid unnecessary waiting times in the
    batch system queue.



## Clone a repository with a link

This feature bases on
[nbgitpuller](https://github.com/jupyterhub/nbgitpuller) (
[documentation](https://jupyterhub.github.io/nbgitpuller/))

This extension for jupyter notebooks can clone every public git
repository into the users work directory. It's offering a quick way to
distribute notebooks and other material to your students.

\<a href="%ATTACHURL%/gitpull_progress.png">\<img alt="Git pull progress
screen" width="475"
src="<https://doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/JupyterHubForTeaching/gitpull_progress.png>"
style="border: 1px solid #888;" title="Git pull progress screen"/>\</a>

A sharable link for this feature looks like this:

<https://taurus.hrsk.tu-dresden.de/jupyter/hub/user-redirect/git-pull?repo=https://github.com/jdwittenauer/ipython-notebooks&urlpath=/tree/ipython-notebooks/notebooks/language/Intro.ipynb>
\<a href="%ATTACHURL%/url-git-pull.png?t=1604588695">\<img alt="URL with
git-pull parameters" width="100%" style="max-width: 2717px"
src="<https://doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/JupyterHubForTeaching/url-git-pull.png?t=1604588695>"
style="border: 1px solid #888;" title="URL with git-pull
parameters"/>\</a>

\<span
style`"font-size: 1em;">This example would clone the repository </span> [[https://github.com/jdwittenauer/ipython-notebooks][github.com/jdwittenauer/ipython-notebooks]]<span style="font-size: 1em;"> and afterwards open the </span> =Intro.ipynb`
\<span style="font-size: 1em;"> notebook in the given path.\</span>

The following parameters are available:

<table>
<thead>
<tr class="header">
<th style="text-align: left;">parameter</th>
<th style="text-align: left;">info</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">repo</td>
<td style="text-align: left;">path to git repository</td>
</tr>
<tr class="even">
<td style="text-align: left;">branch</td>
<td style="text-align: left;">branch in the repository to pull from<br />
default: <code>master</code></td>
</tr>
<tr class="odd">
<td style="text-align: left;">urlpath</td>
<td style="text-align: left;">URL to redirect the user to a certain file<br />
<a href="https://jupyterhub.github.io/nbgitpuller/topic/url-options.html#urlpath">more info</a></td>
</tr>
<tr class="even">
<td style="text-align: left;">depth</td>
<td style="text-align: left;">clone only a certain amount of latest commits<br />
not recommended</td>
</tr>
</tbody>
</table>

This [link
generator](https://jupyterhub.github.io/nbgitpuller/link?hub=https://taurus.hrsk.tu-dresden.de/jupyter/)
might help creating those links

## Spawner options passthrough with URL params

The spawn form now offers a quick start mode by passing url
parameters.  
An example: The following link would create a jupyter notebook session
on the `interactive` partition with the `test` environment being loaded:

    https://taurus.hrsk.tu-dresden.de/jupyter/hub/spawn#/~(partition~'interactive~environment~'test)

/ \<a href="%ATTACHURL%/url-quick-start.png?t=1604586059">\<img alt="URL
with quickstart parameters" width="100%" style="max-width: 800px"
src="<https://doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/JupyterHubForTeaching/url-quick-start.png?t=1604586059>"
style="border: 1px solid #888;" title="URL with quickstart
parameters"/>\</a>

\<span style="font-size: 1em;">Every parameter of the advanced form can
be set with this parameter. If the parameter is not mentioned, the
default value will be loaded.\</span>

| parameter       | default value                            |
|:----------------|:-----------------------------------------|
| partition       | default                                  |
| nodes           | 1                                        |
| ntasks          | 1                                        |
| cpuspertask     | 1                                        |
| gres            | *empty* (no generic resources)           |
| mempercpu       | 1000                                     |
| runtime         | 8:00:00                                  |
| reservation     | *empty* (use no reservation)             |
| project         | *empty* (use default project)            |
| modules         | *empty* (do not load additional modules) |
| environment     | production                               |
| launch          | JupyterLab                               |
| workspace_scope | *empty* (home directory)                 |

You can use the advanced form to generate a url for the settings you
want. The address bar contains the encoded parameters starting with
`#/`.

### Combination of quickstart and git-pull feature

You can combine both features in a single link:

    https://taurus.hrsk.tu-dresden.de/jupyter/hub/user-redirect/git-pull?repo=https://github.com/jdwittenauer/ipython-notebooks&urlpath=/tree/ipython-notebooks/notebooks/language/Intro.ipynb#/~(partition~'interactive~environment~'test)

/ \<a
href="%ATTACHURL%/url-git-pull-and-quick-start.png?t=1604588695">\<img
alt="URL with git-pull and quickstart parameters" width="100%"
style="max-width: 3332px"
src="<https://doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/JupyterHubForTeaching/url-git-pull-and-quick-start.png?t=1604588695>"
style="border: 1px solid #888;" title="URL with git-pull and quickstart
parameters"/>\</a>

## Open a notebook automatically with a single link

With the following link you will be redirected to a certain file in your
home directory. The file needs to exist, otherwise a 404 error will be
thrown.

<https://taurus.hrsk.tu-dresden.de/jupyter/user-redirect/notebooks/demo.ipynb>
\<a href="%ATTACHURL%/url-user-redirect.png">\<img alt="URL with
git-pull and quickstart parameters" width="100%" style="max-width:
700px"
src="<https://doc.zih.tu-dresden.de/hpc-wiki/pub/Compendium/JupyterHubForTeaching/url-user-redirect.png?t=1604587961>"
style="border: 1px solid #888;" title="URL with git-pull and quickstart
parameters"/>\</a>

\<span
style`"font-size: 1em;">This link would redirect to </span> =https://taurus.hrsk.tu-dresden.de/jupyter/user/{login}/notebooks/demo.ipynb`
\<span style="font-size: 1em;">.\</span>
