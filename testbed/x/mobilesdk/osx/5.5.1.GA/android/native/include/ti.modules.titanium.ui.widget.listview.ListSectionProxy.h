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
			namespace ui {


class ListSectionProxy : public titanium::Proxy
{
public:
	explicit ListSectionProxy(jobject javaObject);

	static void bindProxy(v8::Handle<v8::Object> exports);
	static v8::Handle<v8::FunctionTemplate> getProxyTemplate();
	static void dispose();

	static v8::Persistent<v8::FunctionTemplate> proxyTemplate;
	static jclass javaClass;

private:
	// Methods -----------------------------------------------------------
	static v8::Handle<v8::Value> getItemAt(const v8::Arguments&);
	static v8::Handle<v8::Value> setHeaderTitle(const v8::Arguments&);
	static v8::Handle<v8::Value> replaceItemsAt(const v8::Arguments&);
	static v8::Handle<v8::Value> setHeaderView(const v8::Arguments&);
	static v8::Handle<v8::Value> updateItemAt(const v8::Arguments&);
	static v8::Handle<v8::Value> appendItems(const v8::Arguments&);
	static v8::Handle<v8::Value> insertItemsAt(const v8::Arguments&);
	static v8::Handle<v8::Value> getHeaderTitle(const v8::Arguments&);
	static v8::Handle<v8::Value> setItems(const v8::Arguments&);
	static v8::Handle<v8::Value> getItems(const v8::Arguments&);
	static v8::Handle<v8::Value> deleteItemsAt(const v8::Arguments&);
	static v8::Handle<v8::Value> setFooterView(const v8::Arguments&);
	static v8::Handle<v8::Value> setFooterTitle(const v8::Arguments&);
	static v8::Handle<v8::Value> getHeaderView(const v8::Arguments&);
	static v8::Handle<v8::Value> getFooterTitle(const v8::Arguments&);
	static v8::Handle<v8::Value> getFooterView(const v8::Arguments&);

	// Dynamic property accessors ----------------------------------------
	static v8::Handle<v8::Value> getter_footerTitle(v8::Local<v8::String> property, const v8::AccessorInfo& info);
	static void setter_footerTitle(v8::Local<v8::String> property, v8::Local<v8::Value> value, const v8::AccessorInfo& info);
	static v8::Handle<v8::Value> getter_headerView(v8::Local<v8::String> property, const v8::AccessorInfo& info);
	static void setter_headerView(v8::Local<v8::String> property, v8::Local<v8::Value> value, const v8::AccessorInfo& info);
	static v8::Handle<v8::Value> getter_headerTitle(v8::Local<v8::String> property, const v8::AccessorInfo& info);
	static void setter_headerTitle(v8::Local<v8::String> property, v8::Local<v8::Value> value, const v8::AccessorInfo& info);
	static v8::Handle<v8::Value> getter_items(v8::Local<v8::String> property, const v8::AccessorInfo& info);
	static void setter_items(v8::Local<v8::String> property, v8::Local<v8::Value> value, const v8::AccessorInfo& info);
	static v8::Handle<v8::Value> getter_footerView(v8::Local<v8::String> property, const v8::AccessorInfo& info);
	static void setter_footerView(v8::Local<v8::String> property, v8::Local<v8::Value> value, const v8::AccessorInfo& info);

};

			} // namespace ui
		} // titanium
