//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <rive_common/rive_plugin.h>
#include <vosk_flutter/vosk_flutter_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) rive_common_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "RivePlugin");
  rive_plugin_register_with_registrar(rive_common_registrar);
  g_autoptr(FlPluginRegistrar) vosk_flutter_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "VoskFlutterPlugin");
  vosk_flutter_plugin_register_with_registrar(vosk_flutter_registrar);
}
