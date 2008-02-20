# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdialog/kdialog-3.5.9.ebuild,v 1.1 2008/02/20 22:57:12 philantrop Exp $

KMNAME=kdebase
EAPI="1"
inherit kde-meta eutils

DESCRIPTION="KDialog can be used to show nice dialog boxes from shell scripts"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="kdehiddenvisibility"

# Uses cdcontrol on FreeBSD
RDEPEND="kernel_linux? ( || ( >=sys-apps/eject-2.1.5 sys-block/unieject ) ) "

KMEXTRA="kdeeject"
KMNODOCS=true
