# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebase-kioslaves/kdebase-kioslaves-3.5.0.ebuild,v 1.2 2005/11/29 03:39:39 weeve Exp $

KMNAME=kdebase
KMMODULE=kioslave
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="kioslave: the kde VFS framework - kioslave plugins present a filesystem-like view of arbitrary data"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="hal ldap samba openexr"
DEPEND="ldap? ( net-nds/openldap )
	samba? ( >=net-fs/samba-3.0.1 )
	>=dev-libs/cyrus-sasl-2
	hal? ( >=sys-apps/dbus-0.33
	       =sys-apps/hal-0.5* )
	openexr? ( media-libs/openexr )"
RDEPEND="${DEPEND}
	$(deprange $PV $MAXKDEVER kde-base/kdialog)"  # for the kdeeject script used by the devices/mounthelper ioslave

myconf="$myconf `use_with ldap` `use_with samba` `use_with hal` `use_with openexr`"

