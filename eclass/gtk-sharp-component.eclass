# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/gtk-sharp-component.eclass,v 1.24 2006/03/16 07:02:44 latexer Exp $

# Author : Peter Johanson <latexer@gentoo.org>
# Based off of original work in gst-plugins.eclass by <foser@gentoo.org>

inherit eutils mono multilib


LICENSE="LGPL-2"

HOMEPAGE="http://gtk-sharp.sourceforge.net/"
LICENSE="LGPL-2.1"
RESTRICT="test"

[ "${PV:0:1}" == "2" ] \
	&& SOURCE_SERVER="http://www.go-mono.com/sources/gtk-sharp-2.0/"

# Can be switched to [ "${PV:0:3}" == "2.8" ] when 2.8.0 is out of the tree.
[ "${PV}" == "2.8.2" ] \
	&& SOURCE_SERVER="http://www.go-mono.com/sources/gtk-sharp-2.8/"

[ "${PV}" == "1.0.10" ] \
	&& SOURCE_SERVER="http://www.go-mono.com/sources/gtk-sharp/"

[ -z "${SOURCE_SERVER}" ] \
	&& SOURCE_SERVER="mirror://sourceforge/gtk-sharp/"

###
# variable declarations
###

MY_P=gtk-sharp-${PV}

# From gtk-sharp-1.0 series
my_gtk_sharp_components="art gda glade gnome gnomedb gtkhtml rsvg vte"

# Added in gtk-sharp-2.0 series
my_gtk_sharp_components="${my_gtk_sharp_components} gnomevfs panelapplet"

# Version number used to differentiate between unversioned 1.0 series,
# and the versioned 2.0 series (2.0 series has 2 or 2.0 appended to various
# paths and scripts)
GTK_SHARP_COMPONENT_SLOT=""
GTK_SHARP_COMPONENT_SLOT_DEC=""

# Extract the component to build from the ebuild name
# May be set by an ebuild and contain more than one indentifier, space seperated
# (only src_configure can handle mutiple plugins at this time)
GTK_SHARP_COMPONENT_BUILD=${PN/-sharp/}

# Use to enable any other dependancies needed to build this package
GTK_SHARP_COMPONENT_BUILD_DEPS=""

# Actual build dir, is the same as the configure switch name most of the time
GTK_SHARP_COMPONENT_BUILD_DIR=${PN/-sharp/}

DESCRIPTION="${GTK_SHARP_COMPONENT_BUILD} component of gtk-sharp"
SRC_URI="${SOURCE_SERVER}/${MY_P}.tar.gz
		mirror://gentoo/${MY_P}-configurable.diff.gz"

S=${WORKDIR}/${MY_P}

# Make sure we're building with the same version.
DEPEND="=dev-dotnet/${MY_P}*
	sys-devel/automake
	sys-devel/autoconf
	>=sys-apps/sed-4"


###
# public functions
###

gtk-sharp-component_fix_makefiles() {
	GAPI_DIR="${ROOT}/usr/share/gapi${GTK_SHARP_COMPONENT_SLOT_DEC}"
	GAPI_FIXUP="gapi${GTK_SHARP_COMPONENT_SLOT}-fixup"
	GAPI_CODEGEN="gapi${GTK_SHARP_COMPONENT_SLOT}-codegen"
	GTK_SHARP_LIB_DIR="${ROOT}/usr/$(get_libdir)/mono/gtk-sharp${GTK_SHARP_COMPONENT_SLOT_DEC}"

	local makefiles="$(find ${S} -name Makefile.in)"
	# Universal changes needed for all versions
	sed -i -e "s;\(\.\.\|\$(top_srcdir)\)/[[:alpha:]]*/\([[:alpha:]]*\(-[[:alpha:]]*\)*\).xml;${GAPI_DIR}/\2.xml;g" \
		-i -e "s;/r:\(\.\./\)*[[:alpha:]]*/\([[:alpha:]]*\(-[[:alpha:]]*\)*\).dll;/r:${GTK_SHARP_LIB_DIR}/\2.dll;g" \
			${makefiles} || die "Failed to fix the gtk-sharp makefiles"

	if [ "${PV:0:1}" == "2" ] ; then
		sed -i -e "s:\$(SYMBOLS) \$(top_builddir)/parser/gapi-fixup.exe:\$(SYMBOLS):" \
			-e "s:\$(INCLUDE_API) \$(top_builddir)/generator/gapi_codegen.exe:\$(INCLUDE_API):" \
			-e "s:\$(RUNTIME) \$(top_builddir)/parser/gapi-fixup.exe:${GAPI_FIXUP}:" \
			-e "s:\$(RUNTIME) \$(top_builddir)/generator/gapi_codegen.exe:${GAPI_CODEGEN}:" \
			-e "s;\.\./[[:alpha:]]*/\([[:alpha:]]*\(-[[:alpha:]]*\)*\).dll;${GTK_SHARP_LIB_DIR}/\1.dll;g" \
			${makefiles} || die "Failed to fix the gtk-sharp makefiles"
	fi

	# Changes specific to *-sharp-1.0.x
	if [ "${PV:0:3}" = "1.0" ] ; then
		sed -i -e "s:\$(RUNTIME) \.\./parser/gapi-fixup.exe:${GAPI_FIXUP}:" \
			-e "s:\$(RUNTIME) \.\./generator/gapi_codegen.exe:${GAPI_CODEGEN}:" \
			-e "s: \.\./generator/gapi_codegen.exe::" \
			${makefiles} || die "Failed to fix the gtk-sharp makefiles"
	fi
}

gtk-sharp-component_src_unpack() {
	unpack ${A}
	cd ${S}

	# Make the components configurable
	epatch ${WORKDIR}/${MY_P}-configurable.diff
	aclocal || die "aclocal failed"
	# See bug #73563, comment #9
	libtoolize --copy --force || die "libtoolize failed"
	automake || die "automake failed"

	# fixes support with pkgconfig-0.17, bug #92503
	sed -i -e 's/\<PKG_PATH\>/GTK_SHARP_PKG_PATH/g' configure.in

	# Use correct libdir in pkgconfig files
	sed -i -e 's:^libdir.*:libdir=@libdir@:' \
		${S}/*/{,GConf}/*.pc.in || die

	autoconf || die "autoconf failed"

	# disable building of samples (#16015)
	sed -i -e "s:sample::" ${S}/Makefile.in || die

	cd ${S}/${GTK_SHARP_COMPONENT_BUILD_DIR}

	gtk-sharp-component_fix_makefiles
}

gtk-sharp-component_src_configure() {

	# disable any external plugin besides the plugin we want
	local component deps gtk_sharp_conf

	einfo "Configuring to build ${PN} component ..."

	for component in ${GTK_SHARP_COMPONENT_BUILD} ${GTK_SHARP_COMPONENT_BUILD_DEPS}; do
		my_gtk_sharp_components=${my_gtk_sharp_components/${component}/}
	done
	for component in ${my_gtk_sharp_components}; do
		gtk_sharp_conf="${gtk_sharp_conf} --disable-${component} "
	done
	for component in ${GTK_SHARP_COMPONENT_BUILD} ${GTK_SHARP_COMPONENT_BUILD_DEPS}; do
		gtk_sharp_conf="${gtk_sharp_conf} --enable-${component} "
	done

	cd ${S}
	econf ${@} ${gtk_sharp_conf} || die "./configure failure"
}

gtk-sharp-component_src_compile() {
	gtk-sharp-component_src_configure ${@}

	cd ${S}/${GTK_SHARP_COMPONENT_BUILD_DIR}
	LANG=C emake -j1 || die "compile failure"
}

gtk-sharp-component_src_install() {
	cd ${GTK_SHARP_COMPONENT_BUILD_DIR}
	LANG=C make GACUTIL_FLAGS="/root ${D}/usr/$(get_libdir) /gacdir /usr/$(get_libdir) /package gtk-sharp${GTK_SHARP_COMPONENT_SLOT_DEC}" \
		DESTDIR=${D} install || die
}

gtk-sharp-component_pkg_postinst() {
	if [ "${PV:0:3}" == "2.6" ]; then
		ewarn "gtk-sharp-2.6.x is completely, and utterly unsupported by upstream."
		ewarn "If you experience any bugs related to using gtk-sharp-2.6.x, do"
		ewarn "*not* submit them upstream, ask about them on IRC, or email any"
		ewarn "mailinglists. If you think you have found a genuine bug or need help,"
		ewarn "first down grade *all* *-sharp packages to the 2.4.x release and"
		ewarn "test there."
	fi
}

EXPORT_FUNCTIONS src_unpack src_compile src_install pkg_postinst
