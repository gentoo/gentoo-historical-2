# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kapptemplate/kapptemplate-3.5.10.ebuild,v 1.1 2008/09/13 23:57:25 carlo Exp $

RESTRICT="binchecks strip"

KMNAME=kdesdk
EAPI="1"
inherit kde-meta eutils

DESCRIPTION="A shell script that will create the necessary framework to develop various KDE applications."
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

src_install() {
	kde-meta_src_install
	for f in ${KDEDIR}/share/apps/kapptemplate/admin/{bcheck,conf.change,config,detect-autoconf}.pl ; do
		fperms 755 ${f}
	done
}
