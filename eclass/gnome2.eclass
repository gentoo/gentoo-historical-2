# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/gnome2.eclass,v 1.25 2002/09/23 16:08:41 spider Exp $

inherit libtool gnome.org

if [ -n "$DEBUG" ]
then
inherit debug
fi

# Authors:
# Bruce A. Locke <blocke@shivan.org>
# Spidler <spidler@gentoo.org>

# Gnome 2 ECLASS
ECLASS="gnome2"
INHERITED="$INHERITED $ECLASS"
G2CONF=""

if [ -n "$DEBUG" ]; then
  G2CONF="${G2CONF} --enable-debug=yes"
fi

ELTCONF=""
SCROLLKEEPER_UPDATE="1"


gnome2_src_configure() {
	elibtoolize ${ELTCONF}
	# doc keyword for gtk-doc
	use doc && G2CONF="${G2CONF} --enable-gtk-doc" || G2CONF="${G2CONF} --disable-gtk-doc"

	econf ${1} ${G2CONF} || die "./configure failure"

}

gnome2_src_compile() {

	gnome2_src_configure ${1}
	emake || die "compile failure"

}

gnome2_src_install() {

	# if this is not present, scrollkeeper-update may segfault and
	# create bogus directories in /var/lib/
	[ -x ${ROOT}/bin/wc ] && dodir /var/lib/scrollkeeper

	# we must delay gconf schema installation due to sandbox
	export GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL="1"

	einstall " scrollkeeper_localstate_dir=${D}/var/lib/scrollkeeper/ ${1}"

	unset GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL

	# manual document installation
	if [ -n "${DOCS}" ]
	then
		dodoc ${DOCS}
	fi

	# if empty, remove
	[ -x ${ROOT}/bin/wc ] && [ `ls -al ${D}/var/lib/scrollkeeper | wc -l` -eq 3 ] && \
		rm -rf ${D}/var/lib/scrollkeeper
	# only update scrollkeeper if this package needs it
	[ ! -d ${D}/var/lib/scrollkeeper ] && SCROLLKEEPER_UPDATE="0"
}


gnome2_gconf_install() {
	if [ -x ${ROOT}/usr/bin/gconftool-2 ]
	then
	        unset GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL
		export GCONF_CONFIG_SOURCE=`${ROOT}/usr/bin/gconftool-2 --get-default-source`
		einfo "installing gnome2 gconf schemas"	
		cat ${ROOT}/var/db/pkg/*/${PN}-${PVR}/CONTENTS | grep "obj /etc/gconf/schemas" | sed 's:obj \([^ ]*\) .*:\1:' |while read F; do
			echo "DEBUG::gconf install  ${F}"
				${ROOT}/usr/bin/gconftool-2  --makefile-install-rule ${F}
		done
	fi
	# schema installation
}

gnome2_pkg_postinst() {
	gnome2_gconf_install
	
	if [ -x ${ROOT}/usr/bin/scrollkeeper-update ] && [ "${SCROLLKEEPER_UPDATE}" = "1" ]
	then
		echo ">>> Updating Scrollkeeper"
		scrollkeeper-update -p ${ROOT}/var/lib/scrollkeeper
	fi
}

EXPORT_FUNCTIONS src_compile src_install pkg_postinst


