# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/rootstrap/rootstrap-0.3.13.ebuild,v 1.1 2003/09/19 17:55:22 lanius Exp $

DESCRIPTION="A tool for building complete Linux filesystem images"
HOMEPAGE="http://packages.qa.debian.org/rootstrap"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
SRC_URI="http://ftp.debian.org/debian/pool/main/r/rootstrap/rootstrap_${PV}.orig.tar.gz
	http://ftp.debian.org/debian/pool/main/r/rootstrap/rootstrap_${PV}-1.diff.gz"
S=${WORKDIR}/rootstrap-${PV}.orig
DEPEND="sys-kernel/usermode-sources
	dev-util/debootstrap
	app-arch/dpkg
	dev-lang/python
	app-text/docbook-sgml-utils"
IUSE=""

src_unpack() {
	unpack rootstrap_${PV}.orig.tar.gz
	epatch ${DISTDIR}/rootstrap_${PV}-1.diff.gz
	cd ${S}
	sed -i -e "s/docbook-to-man/docbook2man/" Makefile
}

src_compile() {
	emake
}

src_install() {
	make DESTDIR=${D} install
	dodoc COPYING
}
