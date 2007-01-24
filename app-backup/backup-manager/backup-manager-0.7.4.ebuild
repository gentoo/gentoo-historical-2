# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/backup-manager/backup-manager-0.7.4.ebuild,v 1.2 2007/01/24 04:07:56 genone Exp $

inherit eutils

DESCRIPTION="Backup Manager is a command line backup tool for GNU/Linux."
HOMEPAGE="http://www.backup-manager.org/"
SRC_URI="http://www.backup-manager.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

DEPEND="dev-lang/perl
	sys-devel/gettext"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/Makefile-fix.diff
	#epatch ${FILESDIR}/Makefile-perl-path-fix.diff
	epatch ${FILESDIR}/bzip2-path-fix.diff
	epatch ${FILESDIR}/backup-manager-upload-execution-fix-${PV}.diff
}

src_compile() {
	# doing nothing, cause a call to make would start make install
	true
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	use doc && dodoc doc/user-guide.txt
}

pkg_postinst() {
	elog "After installing,"
	elog "copy ${ROOT%/}/usr/share/backup-manager/backup-manager.conf.tpl to /etc/backup-manager.conf"
	elog "and set for your environment."
	elog "You could also set-up your cron for daily or weekly backup."
	ebeep 3
	ewarn "New configuration keys have been defined. Please check the docs for info"
}
