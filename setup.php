<?php

$mageConf = include 'app/etc/env.php';
$redis = [
    'session' =>
        array(
            'save'  => 'redis',
            'redis' =>
                array(
                    'host'                  => getenv('SESSION') ?: 'session',
                    'port'                  => '6379',
                    'password'              => '',
                    'timeout'               => '2.5',
                    'persistent_identifier' => '',
                    'database'              => '0',
                    'compression_threshold' => '2048',
                    'compression_library'   => 'gzip',
                    'log_level'             => '1',
                    'max_concurrency'       => '6',
                    'break_after_frontend'  => '5',
                    'break_after_adminhtml' => '30',
                    'first_lifetime'        => '600',
                    'bot_first_lifetime'    => '60',
                    'bot_lifetime'          => '7200',
                    'disable_locking'       => '0',
                    'min_lifetime'          => '60',
                    'max_lifetime'          => '2592000'
                )
        ),
    'cache'   =>
        array(
            'frontend' =>
                array(
                    'default'    =>
                        array(
                            'backend'         => 'Cm_Cache_Backend_Redis',
                            'backend_options' =>
                                array(
                                    'server'   => getenv('CACHE') ?: 'cache',
                                    'port'     => '6379',
                                    'database' => '0',
                                ),
                        ),
                    'page_cache' =>
                        array(
                            'backend'         => 'Cm_Cache_Backend_Redis',
                            'backend_options' =>
                                array(
                                    'server'        => getenv('CACHE') ?: 'cache',
                                    'port'          => '6379',
                                    'database'      => '1',
                                    'compress_data' => '0'
                                )
                        )
                )
        ),
];

$config = var_export(array_merge($mageConf, $redis),true);
$config =<<<PHP
<?php
return $config;
PHP;

file_put_contents('app/etc/env.php', $config);
