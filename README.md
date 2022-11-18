What is this project ?
----------------------

This project is **NOT** the official Slicer repository.

It is a fork of Slicer sources hosted at https://github.com/Slicer/Slicer.

It is used as staging area to maintain and test patches that will be contributed back to the
official repository.


What is the branch naming convention ?
--------------------------------------

Each branch is named following the pattern `SonoEQApp-vY.Y.Z-YYYY-MM-DD-SHA{7}`

where:

* `vX.Y.Z` is the version of the forked project
* `YYYY-MM-DD` is the date of the last official commit associated with the branch.
* `SHA{9}` are the first seven characters of the last official commit associated with the branch.

For more details, this was based on conventions at https://www.slicer.org/wiki/Documentation/Nightly/Developers/ProjectForks


How to backport changes to a specific branch ?
----------------------------------------------

1. Fork `Slicer/Slicer`

2. Checkout the relevant `SonoEQApp-vX.Y.Z-YYYY-MM-DD-SHA{9}` branch. See [CMakeLists.txt](https://github.com/SonoVol/SonoEQApp/blob/master/CMakeLists.txt) to identify the name of the branch.

3. Add the remote from which to cherry-pick commit from

4. Cherry-pick the commit(s)

5. Amend the commit updating title and message to include `[backport PR-1234]` and `Cherry-picked commit ...` information.

    Adding these details streamlines the creation of new `SonoEQApp-` branch allowing to easily identify which commits are specific to SonoEQApp and which ones have been backported.

    ```
    [backport PR-6675] ENH: Support disconnecting markups toolbar from mouse mode toolbar

    See https://github.com/Slicer/Slicer/pull/6675/commits/ab81e1fa9b46a17e08fc4c10a0658ec9a06efe23

    ...
    ```

    Or if the change has already been integrated into the upstream repository:

    ```
    [backport] BUG: Workaround for Slicer startup hang on Windows11

    numpy has to be loaded early to avoid hang when loading openblas library.
    This is a temporary workaround and may be removed if the related issue is fixed in Windows11 or numpy (or we find a nicer solution in Slicer).

    Cherry-picked commit https://github.com/Slicer/Slicer/commit/542f53c5ba9bf650119707f990e36d74a6c8d36a from main Slicer repository.

    ...
    ```

6. Finally, create a pull request against the relevant `SonoEQApp-vX.Y.Z-YYYY-MM-DD-SHA{9}` branch.


_Note: If you have push access to the `SonoVol/Slicer` fork, you could directly push commit to the relevant branch_


How to update the version of Slicer ?
----------------------------------

1. Clone this repository and add a remote to the official project

```
git clone https://github.com/SonoVol/Slicer
cd Slicer
git remote add upstream https://github.com/Slicer/Slicer
git fetch upstream
```

2. Create a new branch following the branch naming convention mentioned in a section above.

3. Cherry-pick the SonoVol specific commits from the last used `SonoEQApp-vX.Y.Z-YYYY-MM-DD-SHA{9}` branch. Resolve conflicts as needed.

   - the commit hash included in each branch name is the Slicer *upstream* hash, so
     SonoVol specific commits may be viewed with the git range (`..`) operation:
```
          git log --pretty=format:"%h" {SlicerSHA}..SonoEQApp-xyz-{SlicerSHA}
```

4. To **test the changes**, locally rebuild Slicer.

5. Publish the branch. (directly in this repo if you have push rights, or on a fork)

6. Update SonoVol CMakeLists.txt by submitting a pull request.