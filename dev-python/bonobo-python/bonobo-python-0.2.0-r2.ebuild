# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/bonobo-python/bonobo-python-0.2.0-r2.ebuild,v 1.1 2002/12/09 20:08:20 foser Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Bonobo bindings for Python"
SRC_URI="http://bonobo-python.lajnux.nu/download/${P}.tar.gz"
HOMEPAGE="http://bonobo-python.lajnux.nu/"

DEPEND="=x11-libs/gtk+-1.2*
	>=gnome-base/bonobo-1.0.9
	<dev-python/gnome-python-1.99
	=dev-python/orbit-python-0.3*
	virtual/python"
RDEPEND="${RDEPEND}"

SLOT="0"
KEYWORDS="~x86 ~sparc ~alpha"
LICENSE="GPL-2"

src_unpack() {
	unpack ${A}

	# fix configure time sandbox problem
	cd ${S}
	mv configure configure.bad
	sed -e "s:import gnome.config ; gnome.config.sync::" configure.bad > configure
	chmod +x configure
}

src_compile() {
	PYTHON=/usr/bin/python	./configure --host=${CHOST} --prefix=/usr \
		--with-libIDL-prefix=/usr --with-orbit-prefix=/usr \
		--with-oaf-prefix=/usr || die
	make || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog NEWS README TODO
}




