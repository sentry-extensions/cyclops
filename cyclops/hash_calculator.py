#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import hashlib


def _add_stacktrace_valuable_items(obj, valuable_items):
    for value in obj:
        if isinstance(value, dict) and ('stacktrace' in value) and value['stacktrace']:
            if ('frames' in value['stacktrace']) and value['stacktrace']['frames']:
                valuable_items.append(value['stacktrace']['frames'])
                if 'type' in value and value['type']:
                    valuable_items.append(value['type'])


def _add_type_and_value_valuable_items(obj, valuable_items):
    for value in obj:
        if 'value' in value and (value['value']):
            valuable_items.append(value['value'])
            if 'type' in value and value['type']:
                valuable_items.append(value['type'])


def _hash_for_nonempty_obj_or_none(valuable_items):
    if not valuable_items:
        return None

    hash_obj = hashlib.md5()
    hash_obj.update(json.dumps(valuable_items))
    return hash_obj.hexdigest()


def _hash_for_frames_in_exception(exception):
    if ('values' not in exception) or (not isinstance(exception['values'], list)) or not exception['values']:
        return None

    valuable_items = []

    # operates with frames and type only
    _add_stacktrace_valuable_items(exception['values'], valuable_items)
    return _hash_for_nonempty_obj_or_none(valuable_items)


def _hash_for_frames_in_old_node_exception(exception):
    valuable_items = []
    _add_stacktrace_valuable_items(exception, valuable_items)
    return _hash_for_nonempty_obj_or_none(valuable_items)


def _hash_for_value_and_type_in_exception(exception):
    if ('values' not in exception) or (not isinstance(exception['values'], list)) or not exception['values']:
        return None

    valuable_items = []
    _add_type_and_value_valuable_items(exception['values'], valuable_items)
    return _hash_for_nonempty_obj_or_none(valuable_items)


def _hash_for_value_and_type_in_old_node_exception(exception):
    valuable_items = []
    _add_type_and_value_valuable_items(exception, valuable_items)
    return _hash_for_nonempty_obj_or_none(valuable_items)


def _hash_for_frames_in_stacktrace(stacktrace):
    if ('frames' not in stacktrace) or not stacktrace['frames']:
        return None

    hash_obj = hashlib.md5()
    hash_obj.update(json.dumps(stacktrace['frames']))
    return hash_obj.hexdigest()


def hash_for_grouping(payload):
    has_exception = 'exception' in payload and isinstance(payload['exception'], dict)
    has_old_node_exception = 'exception' in payload and isinstance(payload['exception'], list)
    has_stacktrace = 'stacktrace' in payload and isinstance(payload['stacktrace'], dict)
    has_interface_exception = 'sentry.interfaces.Exception' in payload and \
                              isinstance(payload['sentry.interfaces.Exception'], dict)
    has_interface_stacktrace = 'sentry.interfaces.Stacktrace' in payload and \
                               isinstance(payload['sentry.interfaces.Stacktrace'], dict)

    if has_exception:
        exception_frames_hash = _hash_for_frames_in_exception(payload['exception'])
        if exception_frames_hash:
            return exception_frames_hash
        value_and_type = _hash_for_value_and_type_in_exception(payload['exception'])
        if value_and_type:
            return value_and_type

    if has_old_node_exception:
        exception_frames_hash = _hash_for_frames_in_old_node_exception(payload['exception'])
        if exception_frames_hash:
            return exception_frames_hash

    if has_stacktrace:
        stacktrace_frames_hash = _hash_for_frames_in_stacktrace(payload['stacktrace'])
        if stacktrace_frames_hash:
            return stacktrace_frames_hash

    if has_interface_exception:
        exception_frames_hash = _hash_for_frames_in_exception(payload['sentry.interfaces.Exception'])
        if exception_frames_hash:
            return exception_frames_hash

        if has_interface_stacktrace:
            stacktrace_frames_hash = _hash_for_frames_in_stacktrace(payload['sentry.interfaces.Stacktrace'])
            if stacktrace_frames_hash:
                return stacktrace_frames_hash

        value_and_type = _hash_for_value_and_type_in_exception(payload['sentry.interfaces.Exception'])
        if value_and_type:
            return value_and_type

    message_and_culprit = []
    if 'message' in payload and payload['message']:
        message_and_culprit.append(payload['message'])
    elif 'sentry.interfaces.Message' in payload and payload['sentry.interfaces.Message'] and \
         'message' in payload['sentry.interfaces.Message'] and payload['sentry.interfaces.Message']['message']:
        message_and_culprit.append(payload['sentry.interfaces.Message']['message'])

    if 'culprit' in payload and payload['culprit']:
        message_and_culprit.append(payload['culprit'])

    return _hash_for_nonempty_obj_or_none(message_and_culprit)
