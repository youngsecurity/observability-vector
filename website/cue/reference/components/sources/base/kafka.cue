package metadata

base: components: sources: kafka: configuration: {
	acknowledgements: {
		deprecated: true
		description: """
			Controls how acknowledgements are handled by this source.

			This setting is **deprecated** in favor of enabling `acknowledgements` at the [global][global_acks] or sink level.

			Enabling or disabling acknowledgements at the source level has **no effect** on acknowledgement behavior.

			See [End-to-end Acknowledgements][e2e_acks] for more information on how event acknowledgement is handled.

			[global_acks]: https://vector.dev/docs/reference/configuration/global-options/#acknowledgements
			[e2e_acks]: https://vector.dev/docs/about/under-the-hood/architecture/end-to-end-acknowledgements/
			"""
		required: false
		type: object: options: enabled: {
			description: "Whether or not end-to-end acknowledgements are enabled for this source."
			required:    false
			type: bool: {}
		}
	}
	auto_offset_reset: {
		description: """
			If offsets for consumer group do not exist, set them using this strategy.

			See the [librdkafka documentation](https://github.com/edenhill/librdkafka/blob/master/CONFIGURATION.md) for the `auto.offset.reset` option for further clarification.
			"""
		required: false
		type: string: {
			default: "largest"
			examples: ["smallest", "earliest", "beginning", "largest", "latest", "end", "error"]
		}
	}
	bootstrap_servers: {
		description: """
			A comma-separated list of Kafka bootstrap servers.

			These are the servers in a Kafka cluster that a client should use to bootstrap its connection to the cluster,
			allowing discovery of all the other hosts in the cluster.

			Must be in the form of `host:port`, and comma-separated.
			"""
		required: true
		type: string: examples: ["10.14.22.123:9092,10.14.23.332:9092"]
	}
	commit_interval_ms: {
		description: "The frequency that the consumer offsets are committed (written) to offset storage."
		required:    false
		type: uint: {
			default: 5000
			examples: [5000, 10000]
			unit: "milliseconds"
		}
	}
	decoding: {
		description: "Configures how events are decoded from raw bytes."
		required:    false
		type: object: options: {
			codec: {
				description: "The codec to use for decoding events."
				required:    false
				type: string: {
					default: "bytes"
					enum: {
						bytes: "Uses the raw bytes as-is."
						gelf: """
															Decodes the raw bytes as a [GELF][gelf] message.

															[gelf]: https://docs.graylog.org/docs/gelf
															"""
						json: """
															Decodes the raw bytes as [JSON][json].

															[json]: https://www.json.org/
															"""
						native: """
															Decodes the raw bytes as Vector’s [native Protocol Buffers format][vector_native_protobuf].

															This codec is **[experimental][experimental]**.

															[vector_native_protobuf]: https://github.com/vectordotdev/vector/blob/master/lib/vector-core/proto/event.proto
															[experimental]: https://vector.dev/highlights/2022-03-31-native-event-codecs
															"""
						native_json: """
															Decodes the raw bytes as Vector’s [native JSON format][vector_native_json].

															This codec is **[experimental][experimental]**.

															[vector_native_json]: https://github.com/vectordotdev/vector/blob/master/lib/codecs/tests/data/native_encoding/schema.cue
															[experimental]: https://vector.dev/highlights/2022-03-31-native-event-codecs
															"""
						protobuf: """
															Decodes the raw bytes as [protobuf][protobuf].

															[protobuf]: https://protobuf.dev/
															"""
						syslog: """
															Decodes the raw bytes as a Syslog message.

															Decodes either as the [RFC 3164][rfc3164]-style format ("old" style) or the
															[RFC 5424][rfc5424]-style format ("new" style, includes structured data).

															[rfc3164]: https://www.ietf.org/rfc/rfc3164.txt
															[rfc5424]: https://www.ietf.org/rfc/rfc5424.txt
															"""
					}
				}
			}
			gelf: {
				description:   "GELF-specific decoding options."
				relevant_when: "codec = \"gelf\""
				required:      false
				type: object: options: lossy: {
					description: """
						Determines whether or not to replace invalid UTF-8 sequences instead of failing.

						When true, invalid UTF-8 sequences are replaced with the [`U+FFFD REPLACEMENT CHARACTER`][U+FFFD].

						[U+FFFD]: https://en.wikipedia.org/wiki/Specials_(Unicode_block)#Replacement_character
						"""
					required: false
					type: bool: default: true
				}
			}
			json: {
				description:   "JSON-specific decoding options."
				relevant_when: "codec = \"json\""
				required:      false
				type: object: options: lossy: {
					description: """
						Determines whether or not to replace invalid UTF-8 sequences instead of failing.

						When true, invalid UTF-8 sequences are replaced with the [`U+FFFD REPLACEMENT CHARACTER`][U+FFFD].

						[U+FFFD]: https://en.wikipedia.org/wiki/Specials_(Unicode_block)#Replacement_character
						"""
					required: false
					type: bool: default: true
				}
			}
			native_json: {
				description:   "Vector's native JSON-specific decoding options."
				relevant_when: "codec = \"native_json\""
				required:      false
				type: object: options: lossy: {
					description: """
						Determines whether or not to replace invalid UTF-8 sequences instead of failing.

						When true, invalid UTF-8 sequences are replaced with the [`U+FFFD REPLACEMENT CHARACTER`][U+FFFD].

						[U+FFFD]: https://en.wikipedia.org/wiki/Specials_(Unicode_block)#Replacement_character
						"""
					required: false
					type: bool: default: true
				}
			}
			protobuf: {
				description:   "Protobuf-specific decoding options."
				relevant_when: "codec = \"protobuf\""
				required:      false
				type: object: options: {
					desc_file: {
						description: "Path to desc file"
						required:    false
						type: string: default: ""
					}
					message_type: {
						description: "message type. e.g package.message"
						required:    false
						type: string: default: ""
					}
				}
			}
			syslog: {
				description:   "Syslog-specific decoding options."
				relevant_when: "codec = \"syslog\""
				required:      false
				type: object: options: lossy: {
					description: """
						Determines whether or not to replace invalid UTF-8 sequences instead of failing.

						When true, invalid UTF-8 sequences are replaced with the [`U+FFFD REPLACEMENT CHARACTER`][U+FFFD].

						[U+FFFD]: https://en.wikipedia.org/wiki/Specials_(Unicode_block)#Replacement_character
						"""
					required: false
					type: bool: default: true
				}
			}
		}
	}
	fetch_wait_max_ms: {
		description: "Maximum time the broker may wait to fill the response."
		required:    false
		type: uint: {
			default: 100
			examples: [50, 100]
			unit: "milliseconds"
		}
	}
	framing: {
		description: """
			Framing configuration.

			Framing handles how events are separated when encoded in a raw byte form, where each event is
			a frame that must be prefixed, or delimited, in a way that marks where an event begins and
			ends within the byte stream.
			"""
		required: false
		type: object: options: {
			character_delimited: {
				description:   "Options for the character delimited decoder."
				relevant_when: "method = \"character_delimited\""
				required:      true
				type: object: options: {
					delimiter: {
						description: "The character that delimits byte sequences."
						required:    true
						type: uint: {}
					}
					max_length: {
						description: """
																The maximum length of the byte buffer.

																This length does *not* include the trailing delimiter.

																By default, there is no maximum length enforced. If events are malformed, this can lead to
																additional resource usage as events continue to be buffered in memory, and can potentially
																lead to memory exhaustion in extreme cases.

																If there is a risk of processing malformed data, such as logs with user-controlled input,
																consider setting the maximum length to a reasonably large value as a safety net. This
																ensures that processing is not actually unbounded.
																"""
						required: false
						type: uint: {}
					}
				}
			}
			method: {
				description: "The framing method."
				required:    false
				type: string: {
					default: "bytes"
					enum: {
						bytes:               "Byte frames are passed through as-is according to the underlying I/O boundaries (for example, split between messages or stream segments)."
						character_delimited: "Byte frames which are delimited by a chosen character."
						length_delimited:    "Byte frames which are prefixed by an unsigned big-endian 32-bit integer indicating the length."
						newline_delimited:   "Byte frames which are delimited by a newline character."
						octet_counting: """
															Byte frames according to the [octet counting][octet_counting] format.

															[octet_counting]: https://tools.ietf.org/html/rfc6587#section-3.4.1
															"""
					}
				}
			}
			newline_delimited: {
				description:   "Options for the newline delimited decoder."
				relevant_when: "method = \"newline_delimited\""
				required:      false
				type: object: options: max_length: {
					description: """
						The maximum length of the byte buffer.

						This length does *not* include the trailing delimiter.

						By default, there is no maximum length enforced. If events are malformed, this can lead to
						additional resource usage as events continue to be buffered in memory, and can potentially
						lead to memory exhaustion in extreme cases.

						If there is a risk of processing malformed data, such as logs with user-controlled input,
						consider setting the maximum length to a reasonably large value as a safety net. This
						ensures that processing is not actually unbounded.
						"""
					required: false
					type: uint: {}
				}
			}
			octet_counting: {
				description:   "Options for the octet counting decoder."
				relevant_when: "method = \"octet_counting\""
				required:      false
				type: object: options: max_length: {
					description: "The maximum length of the byte buffer."
					required:    false
					type: uint: {}
				}
			}
		}
	}
	group_id: {
		description: "The consumer group name to be used to consume events from Kafka."
		required:    true
		type: string: examples: ["consumer-group-name"]
	}
	headers_key: {
		description: """
			Overrides the name of the log field used to add the headers to each event.

			The value is the headers of the Kafka message itself.

			By default, `"headers"` is used.
			"""
		required: false
		type: string: {
			default: "headers"
			examples: ["headers"]
		}
	}
	key_field: {
		description: """
			Overrides the name of the log field used to add the message key to each event.

			The value is the message key of the Kafka message itself.

			By default, `"message_key"` is used.
			"""
		required: false
		type: string: {
			default: "message_key"
			examples: ["message_key"]
		}
	}
	librdkafka_options: {
		description: """
			Advanced options set directly on the underlying `librdkafka` client.

			See the [librdkafka documentation](https://github.com/edenhill/librdkafka/blob/master/CONFIGURATION.md) for details.
			"""
		required: false
		type: object: {
			examples: [{
				"client.id":                "${ENV_VAR}"
				"fetch.error.backoff.ms":   "1000"
				"socket.send.buffer.bytes": "100"
			}]
			options: "*": {
				description: "A librdkafka configuration option."
				required:    true
				type: string: {}
			}
		}
	}
	metrics: {
		description: "Metrics configuration."
		required:    false
		type: object: options: topic_lag_metric: {
			description: "Expose topic lag metrics for all topics and partitions. Metric names are `kafka_consumer_lag`."
			required:    false
			type: bool: default: false
		}
	}
	offset_key: {
		description: """
			Overrides the name of the log field used to add the offset to each event.

			The value is the offset of the Kafka message itself.

			By default, `"offset"` is used.
			"""
		required: false
		type: string: {
			default: "offset"
			examples: [
				"offset",
			]
		}
	}
	partition_key: {
		description: """
			Overrides the name of the log field used to add the partition to each event.

			The value is the partition from which the Kafka message was consumed from.

			By default, `"partition"` is used.
			"""
		required: false
		type: string: {
			default: "partition"
			examples: ["partition"]
		}
	}
	sasl: {
		description: "Configuration for SASL authentication when interacting with Kafka."
		required:    false
		type: object: options: {
			enabled: {
				description: """
					Enables SASL authentication.

					Only `PLAIN`- and `SCRAM`-based mechanisms are supported when configuring SASL authentication using `sasl.*`. For
					other mechanisms, `librdkafka_options.*` must be used directly to configure other `librdkafka`-specific values.
					If using `sasl.kerberos.*` as an example, where `*` is `service.name`, `principal`, `kinit.md`, etc., then
					`librdkafka_options.*` as a result becomes `librdkafka_options.sasl.kerberos.service.name`,
					`librdkafka_options.sasl.kerberos.principal`, etc.

					See the [librdkafka documentation](https://github.com/edenhill/librdkafka/blob/master/CONFIGURATION.md) for details.

					SASL authentication is not supported on Windows.
					"""
				required: false
				type: bool: {}
			}
			mechanism: {
				description: "The SASL mechanism to use."
				required:    false
				type: string: examples: ["SCRAM-SHA-256", "SCRAM-SHA-512"]
			}
			password: {
				description: "The SASL password."
				required:    false
				type: string: examples: ["password"]
			}
			username: {
				description: "The SASL username."
				required:    false
				type: string: examples: ["username"]
			}
		}
	}
	session_timeout_ms: {
		description: "The Kafka session timeout."
		required:    false
		type: uint: {
			default: 10000
			examples: [5000, 10000]
			unit: "milliseconds"
		}
	}
	socket_timeout_ms: {
		description: "Timeout for network requests."
		required:    false
		type: uint: {
			default: 60000
			examples: [30000, 60000]
			unit: "milliseconds"
		}
	}
	tls: {
		description: "Configures the TLS options for incoming/outgoing connections."
		required:    false
		type: object: options: {
			alpn_protocols: {
				description: """
					Sets the list of supported ALPN protocols.

					Declare the supported ALPN protocols, which are used during negotiation with peer. They are prioritized in the order
					that they are defined.
					"""
				required: false
				type: array: items: type: string: examples: ["h2"]
			}
			ca_file: {
				description: """
					Absolute path to an additional CA certificate file.

					The certificate must be in the DER or PEM (X.509) format. Additionally, the certificate can be provided as an inline string in PEM format.
					"""
				required: false
				type: string: examples: ["/path/to/certificate_authority.crt"]
			}
			crt_file: {
				description: """
					Absolute path to a certificate file used to identify this server.

					The certificate must be in DER, PEM (X.509), or PKCS#12 format. Additionally, the certificate can be provided as
					an inline string in PEM format.

					If this is set, and is not a PKCS#12 archive, `key_file` must also be set.
					"""
				required: false
				type: string: examples: ["/path/to/host_certificate.crt"]
			}
			enabled: {
				description: """
					Whether or not to require TLS for incoming or outgoing connections.

					When enabled and used for incoming connections, an identity certificate is also required. See `tls.crt_file` for
					more information.
					"""
				required: false
				type: bool: {}
			}
			key_file: {
				description: """
					Absolute path to a private key file used to identify this server.

					The key must be in DER or PEM (PKCS#8) format. Additionally, the key can be provided as an inline string in PEM format.
					"""
				required: false
				type: string: examples: ["/path/to/host_certificate.key"]
			}
			key_pass: {
				description: """
					Passphrase used to unlock the encrypted key file.

					This has no effect unless `key_file` is set.
					"""
				required: false
				type: string: examples: ["${KEY_PASS_ENV_VAR}", "PassWord1"]
			}
			verify_certificate: {
				description: """
					Enables certificate verification.

					If enabled, certificates must not be expired and must be issued by a trusted
					issuer. This verification operates in a hierarchical manner, checking that the leaf certificate (the
					certificate presented by the client/server) is not only valid, but that the issuer of that certificate is also valid, and
					so on until the verification process reaches a root certificate.

					Relevant for both incoming and outgoing connections.

					Do NOT set this to `false` unless you understand the risks of not verifying the validity of certificates.
					"""
				required: false
				type: bool: {}
			}
			verify_hostname: {
				description: """
					Enables hostname verification.

					If enabled, the hostname used to connect to the remote host must be present in the TLS certificate presented by
					the remote host, either as the Common Name or as an entry in the Subject Alternative Name extension.

					Only relevant for outgoing connections.

					Do NOT set this to `false` unless you understand the risks of not verifying the remote hostname.
					"""
				required: false
				type: bool: {}
			}
		}
	}
	topic_key: {
		description: """
			Overrides the name of the log field used to add the topic to each event.

			The value is the topic from which the Kafka message was consumed from.

			By default, `"topic"` is used.
			"""
		required: false
		type: string: {
			default: "topic"
			examples: [
				"topic",
			]
		}
	}
	topics: {
		description: """
			The Kafka topics names to read events from.

			Regular expression syntax is supported if the topic begins with `^`.
			"""
		required: true
		type: array: items: type: string: examples: ["^(prefix1|prefix2)-.+", "topic-1", "topic-2"]
	}
}
