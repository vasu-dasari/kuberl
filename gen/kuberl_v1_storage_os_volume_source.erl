-module(kuberl_v1_storage_os_volume_source).

-export([encode/1]).

-export_type([kuberl_v1_storage_os_volume_source/0]).

-type kuberl_v1_storage_os_volume_source() ::
    #{ 'fsType' => binary(),
       'readOnly' => boolean(),
       'secretRef' => kuberl_v1_local_object_reference:kuberl_v1_local_object_reference(),
       'volumeName' => binary(),
       'volumeNamespace' => binary()
     }.

encode(#{ 'fsType' := FsType,
          'readOnly' := ReadOnly,
          'secretRef' := SecretRef,
          'volumeName' := VolumeName,
          'volumeNamespace' := VolumeNamespace
        }) ->
    #{ 'fsType' => FsType,
       'readOnly' => ReadOnly,
       'secretRef' => SecretRef,
       'volumeName' => VolumeName,
       'volumeNamespace' => VolumeNamespace
     }.
