# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libnl/libnl-1.1-r2.ebuild,v 1.10 2011/01/21 15:44:43 jer Exp $

EAPI="2"

inherit eutils multilib

DESCRIPTION="A library for applications dealing with netlink socket"
HOMEPAGE="http://people.suug.ch/~tgr/libnl/"
SRC_URI="http://people.suug.ch/~tgr/libnl/files/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="doc"

DEPEND="doc? ( app-doc/doxygen )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-vlan-header.patch
	epatch "${FILESDIR}"/${P}-minor-leaks.patch
	epatch "${FILESDIR}"/${P}-glibc-2.8-ULONG_MAX.patch
	epatch "${FILESDIR}"/${P}-flags.patch
}

src_compile() {
	default

	if use doc ; then
		cd "${S}/doc"
		emake gendoc || die "emake gendoc failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog

	if use doc ; then
		cd "${S}/doc"
		dohtml -r html/*
	fi
}
