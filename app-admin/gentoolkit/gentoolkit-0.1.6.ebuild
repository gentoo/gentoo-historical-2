# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Karl Trygve Kalleberg <karltk@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-admin/gentoolkit/gentoolkit-0.1.6.ebuild,v 1.1 2002/03/23 00:09:07 karltk Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Collection of unofficial administration scripts for Gentoo"
SRC_URI=""
HOMEPAGE="http://"

DEPEND=""
RDEPEND=">=dev-lang/python-2.0
	>=dev-util/dialog-0.7
	>=sys-devel/perl-5.6"

src_install () {
	dodir /usr/share/gentoolkit

	insinto /usr/share/gentoolkit
	doins ${FILESDIR}/portage-statistics/histogram.awk

	dosbin ${FILESDIR}/portage-statistics/pst-total-coverage
	dosbin ${FILESDIR}/portage-statistics/pst-author-coverage
	dosbin ${FILESDIR}/portage-statistics/pst-package-count
	docinto portage-statistics
	dodoc ${FILESDIR}/portage-statistics/ChangeLog

	dosbin ${FILESDIR}/scripts/qpkg
	doman ${FILESDIR}/scripts/qpkg.1

	dosbin ${FILESDIR}/scripts/pkg-clean
	dosbin ${FILESDIR}/scripts/mkebuild
	dosbin ${FILESDIR}/scripts/emerge-webrsync
	dosbin ${FILESDIR}/scripts/epm

	dosbin ${FILESDIR}/lintool/lintool
	doman ${FILESDIR}/lintool/lintool.1
	docinto lintool
	dodoc ${FILESDIR}/lintool/{checklist-for-ebuilds,ChangeLog}

	dosbin ${FILESDIR}/etc-update/etc-update
	doman ${FILESDIR}/etc-update/etc-update.1
	docinto etc-update
	dodoc ${FILESDIR}/etc-update/ChangeLog
	insinto /etc	
	doins ${FILESDIR}/etc-update/etc-update.conf
}
