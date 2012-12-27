# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gconf/gconf-3.2.5.ebuild,v 1.5 2012/12/27 18:05:52 tetromino Exp $

EAPI="5"
GCONF_DEBUG="yes"
GNOME_ORG_MODULE="GConf"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2

DESCRIPTION="GNOME configuration system and daemon"
HOMEPAGE="http://projects.gnome.org/gconf/"

LICENSE="LGPL-2+"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="debug gtk +introspection ldap orbit policykit"

RDEPEND=">=dev-libs/glib-2.31:2
	>=dev-libs/dbus-glib-0.74
	>=sys-apps/dbus-1
	>=dev-libs/libxml2-2:2
	gtk? ( >=x11-libs/gtk+-2.90:3 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	ldap? ( net-nds/openldap:= )
	orbit? ( >=gnome-base/orbit-2.4:2 )
	policykit? ( sys-auth/polkit )"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35
	virtual/pkgconfig"

src_prepare() {
	G2CONF="${G2CONF}
		--disable-static
		--enable-gsettings-backend
		$(use_enable gtk)
		"$(usex gtk --with-gtk=3.0 "")"
		$(use_enable introspection)
		$(use_with ldap openldap)
		$(use_enable orbit)
		$(use_enable policykit defaults-service)
		ORBIT_IDL=$(type -P orbit-idl-2)"
		# Need host's IDL compiler for cross or native build, bug #262747
	kill_gconf

	gnome2_src_prepare

	# Do not start gconfd when installing schemas, fix bug #238276, upstream #631983
	epatch "${FILESDIR}/${PN}-2.24.0-no-gconfd.patch"

	# Do not crash in gconf_entry_set_value() when entry pointer is NULL, upstream #631985
	epatch "${FILESDIR}/${PN}-2.28.0-entry-set-value-sigsegv.patch"
}

src_install() {
	gnome2_src_install

	keepdir /etc/gconf/gconf.xml.mandatory
	keepdir /etc/gconf/gconf.xml.defaults
	# Make sure this directory exists, bug #268070, upstream #572027
	keepdir /etc/gconf/gconf.xml.system

	echo 'CONFIG_PROTECT_MASK="${EPREFIX}/etc/gconf"' > 50gconf
	echo 'GSETTINGS_BACKEND="gconf"' >> 50gconf
	doenvd 50gconf
	dodir /root/.gconfd
}

pkg_preinst() {
	kill_gconf
}

pkg_postinst() {
	kill_gconf

	# change the permissions to avoid some gconf bugs
	einfo "changing permissions for gconf dirs"
	find  /etc/gconf/ -type d -exec chmod ugo+rx "{}" \;

	einfo "changing permissions for gconf files"
	find  /etc/gconf/ -type f -exec chmod ugo+r "{}" \;

	if ! use orbit; then
		ewarn "You are using dbus for GConf's IPC. If you are upgrading from"
		ewarn "<=gconf-3.2.3, or were previously using gconf with USE=orbit,"
		ewarn "you will need to now restart your desktop session (for example,"
		ewarn "by logging out and then back in)."
		ewarn "Otherwise, gconf-based applications may crash with 'Method ..."
		ewarn "on interface \"org.gnome.GConf.Server\" doesn't exist' errors."
	fi
}

kill_gconf() {
	# This function will kill all running gconfd-2 that could be causing troubles
	if [ -x /usr/bin/gconftool-2 ]
	then
		/usr/bin/gconftool-2 --shutdown
	fi

	return 0
}
