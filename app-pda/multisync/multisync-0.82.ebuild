# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/multisync/multisync-0.82.ebuild,v 1.9 2005/01/01 15:46:05 eradicator Exp $

inherit eutils

DESCRIPTION="Client to sync apps with WinCE or mobile devices"
HOMEPAGE="http://multisync.sourceforge.net/"
SRC_URI="mirror://sourceforge/multisync/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64 ~ppc"
IUSE="evo irmc opie ldap bluetooth"
# evo   - evolution plugin
# irmc  - bluetooth/irmc/irda plugin ( local )
# opie  - opie plugin                ( local )
# ldap  - ldap plugin - experimental

DEPEND=">=gnome-base/libbonobo-2.2
	>=gnome-base/libgnomeui-2.2
	>=gnome-base/libgnome-2.2
	>=dev-libs/glib-2
	>=gnome-base/gconf-2
	>=gnome-base/gnome-vfs-2.2
	>=gnome-base/orbit-2.8.2
	>=dev-libs/openssl-0.9.6j
	evo?  ( =mail-client/evolution-1.4* )
	irmc? ( >=net-wireless/irda-utils-0.9.15
		>=dev-libs/openobex-1
		bluetooth? ( >=net-wireless/bluez-libs-2.7
			         >=net-wireless/bluez-utils-2.7 )
	)
	opie? ( >=net-misc/curl-7.10.5 )
	ldap? ( >=net-nds/openldap-2.0.27
		>=dev-libs/cyrus-sasl-2.1.4 )"

make_plugin_list() {
	export PLUGINS="backup_plugin syncml_plugin"
	use irmc && PLUGINS="${PLUGINS} irmc_sync"
	use evo && PLUGINS="${PLUGINS} evolution_sync"
	use opie && PLUGINS="${PLUGINS} opie_sync"
	use ldap && PLUGINS="${PLUGINS} ldap_plugin"
}

src_unpack() {
	unpack ${A}

	# Fix the opie Makefile
	cd ${S}
	epatch ${FILESDIR}/${PN}-0.81-gentoo.patch
	# Fix for sdp lib bug #63743
	epatch ${FILESDIR}/${PN}-0.82-bluetooth-sdp.patch
	epatch ${FILESDIR}/${PN}-0.82-bluetooth-sdp-2.patch
}

src_compile() {
	make_plugin_list

	einfo "Building Multisync with these plugins:"
	for plugin_dir in ${PLUGINS}
	do
		einfo "      ${plugin_dir}"
	done

	cd ${S}
	econf || die
	make || die "Multisync make failed"

	cd ${S}/plugins
	for plugin_dir in ${PLUGINS}
	do
		cd ${S}/plugins/${plugin_dir}
		econf || die "${plugin_dir} config failed!"
		make || die "${plugin_dir} make failed!"
	done
}

src_install() {
	make_plugin_list
	einstall || die "Multisync install failed!"
	for plugin_dir in ${PLUGINS}
	do
		cd ${S}/plugins/${plugin_dir}
		einstall || die "${plugin_dir} make failed!"
	done
}
