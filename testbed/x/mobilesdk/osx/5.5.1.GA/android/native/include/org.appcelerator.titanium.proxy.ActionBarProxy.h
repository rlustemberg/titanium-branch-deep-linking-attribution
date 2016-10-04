/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

/** This is generated, do not edit by hand. **/

#include <jni.h>

#include "Proxy.h"

		namespace titanium {


class ActionBarProxy : public titanium::Proxy
{
public:
	explicit ActionBarProxy(jobject javaObject);

	static void bindProxy(v8::Handle<v8::Object> exports);
	static v8::Handle<v8::FunctionTemplate> getProxyTemplate();
	static void dispose();

	static v8::Persistent<v8::FunctionTemplate> proxyTemplate;
	static jclass javaClass;

private:
	// Methods -----------------------------------------------------------
	static v8::Handle<v8::Value> setLogo(const v8::Arguments&);
	static v8::Handle<v8::Value> getSubtitle(const v8::Arguments&);
	static v8::Handle<v8::Value> setBackgroundImage(const v8::Arguments&);
	static v8::Handle<v8::Value> show(const v8::Arguments&);
	static v8::Handle<v8::Value> setDisplayShowTitleEnabled(const v8::Arguments&);
	static v8::Handle<v8::Value> hide(const v8::Arguments&);
	static v8::Handle<v8::Value> setNavigationMode(const v8::Arguments&);
	static v8::Handle<v8::Value> getNavigationMode(const v8::Arguments&);
	static v8::Handle<v8::Value> setTitle(const v8::Arguments&);
	static v8::Handle<v8::Value> setHomeButtonEnabled(const v8::Arguments&);
	static v8::Handle<v8::Value> setDisplayShowHomeEnabled(const v8::Arguments&);
	static v8::Handle<v8::Value> setSubtitle(const v8::Arguments&);
	static v8::Handle<v8::Value> getTitle(const v8::Arguments&);
	static v8::Handle<v8::Value> setDisplayHomeAsUp(const v8::Arguments&);
	static v8::Handle<v8::Value> setIcon(const v8::Arguments&);

	// Dynamic property accessors ----------------------------------------
	static void setter_logo(v8::Local<v8::String> property, v8::Local<v8::Value> value, const v8::AccessorInfo& info);
	static void setter_icon(v8::Local<v8::String> property, v8::Local<v8::Value> value, const v8::AccessorInfo& info);
	static v8::Handle<v8::Value> getter_title(v8::Local<v8::String> property, const v8::AccessorInfo& info);
	static void setter_title(v8::Local<v8::String> property, v8::Local<v8::Value> value, const v8::AccessorInfo& info);
	static void setter_homeButtonEnabled(v8::Local<v8::String> property, v8::Local<v8::Value> value, const v8::AccessorInfo& info);
	static void setter_displayHomeAsUp(v8::Local<v8::String> property, v8::Local<v8::Value> value, const v8::AccessorInfo& info);
	static v8::Handle<v8::Value> getter_subtitle(v8::Local<v8::String> property, const v8::AccessorInfo& info);
	static void setter_subtitle(v8::Local<v8::String> property, v8::Local<v8::Value> value, const v8::AccessorInfo& info);
	static void setter_backgroundImage(v8::Local<v8::String> property, v8::Local<v8::Value> value, const v8::AccessorInfo& info);
	static v8::Handle<v8::Value> getter_navigationMode(v8::Local<v8::String> property, const v8::AccessorInfo& info);
	static void setter_navigationMode(v8::Local<v8::String> property, v8::Local<v8::Value> value, const v8::AccessorInfo& info);

};

		} // titanium
