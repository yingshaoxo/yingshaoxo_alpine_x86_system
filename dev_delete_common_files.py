import os
from auto_everything.disk import Disk
disk = Disk()

old_files = {one[len("./disk_data/"):]: {"path": one, "hash": os.path.getsize(one)} for one in disk.get_files("./disk_data")}
new_files = {one[len("./disk_data_new/"):]: {"path": one, "hash": os.path.getsize(one)} for one in disk.get_files("./disk_data_new")}

new_files_that_need_to_delete = set(list(old_files.keys()))
new_files_that_need_to_delete.remove("install_system.sh")
new_files_that_need_to_delete.remove("rsync")

for file in old_files.keys():
    if file in new_files.keys():
        old_hash = old_files[file]["hash"]
        new_hash = new_files[file]["hash"]
        if old_hash != new_hash:
            new_files_that_need_to_delete.remove(file)

for file in new_files_that_need_to_delete:
    disk.delete_a_file(new_files[file]["path"])
