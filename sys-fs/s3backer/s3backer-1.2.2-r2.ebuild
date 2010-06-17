# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/s3backer/s3backer-1.2.2-r2.ebuild,v 1.1 2010/06/17 17:17:16 hwoarang Exp $

EAPI="2"

inherit autotools eutils

DESCRIPTION="FUSE-based single file backing store via Amazon S3"
HOMEPAGE="http://code.google.com/p/s3backer"
SRC_URI="http://s3backer.googlecode.com/files/s3backer-${PV}.tar.gz"
LICENSE="GPL-2"
DEPEND="net-misc/curl
	sys-fs/fuse
	sys-libs/zlib
	dev-libs/expat
	dev-libs/openssl"
RDEPEND="${DEPEND}"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${PN}-qa.patch
	# fix documentation installation wrt bug #294271
	sed -i "/^docdir/s:packages.*:${PF}:" Makefile.am
	eautoreconf
}

src_configure() {
	econf --prefix=/ --exec-prefix=/usr --localstatedir=/var || die "econf failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "Install failed"
}
