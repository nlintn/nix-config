{
  deepseekApiKey,
  morpheusApiKey,
  ...
}:

{
  deepseek.settings.apiKey = "{file:${deepseekApiKey}}";
  morpheus = {
    name = "Morpheus";
    settings = {
      baseURL = "https://morpheus.cit.tum.de/api/v1";
      apiKey = "{file:${morpheusApiKey}}";
    };
    package = "@opencode/ai/providers/openai-compatible";
    models = {
      "cyankiwi/Qwen3.8-Flash-Next-AWQ-INT4" = {
        name = "Qwen3.8 Flash Next";
        capabilities = {
          tools = true;
          input = [
            "text"
            "image"
          ];
          output = [ "text" ];
        };
        limit = {
          context = 262144;
        };
        variants = [
          {
            id = "off";
            body = {
              chat_template_kwargs = {
                enable_thinking = false;
              };
            };
          }
          {
            id = "low";
            body = {
              chat_template_kwargs = {
                enable_thinking = true;
                preserve_thinking = true;
              };
              reasoning_effort = "low";
            };
          }
          {
            id = "medium";
            body = {
              chat_template_kwargs = {
                enable_thinking = true;
                preserve_thinking = true;
              };
              reasoning_effort = "medium";
            };
          }
          {
            id = "xhigh";
            body = {
              chat_template_kwargs = {
                enable_thinking = true;
                preserve_thinking = true;
              };
              reasoning_effort = "xhigh";
            };
          }
        ];
      };
      "google/gemma-4-31B-it" = {
        capabilities = {
          input = [
            "text"
            "image"
          ];
          output = [ "text" ];
          tools = true;
        };
        limit = {
          context = 262144;
        };
        name = "Gemma 4 (31B)";
        variants = [
          {
            id = "off";
            body = {
              chat_template_kwargs = {
                enable_thinking = false;
              };
            };
          }
          {
            id = "on";
            body = {
              chat_template_kwargs = {
                enable_thinking = true;
              };
            };
          }
        ];
      };
    };
  };
}
