# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ada/florist/florist-3.15p.ebuild,v 1.7 2004/06/29 14:54:06 agriffis Exp $

inherit gnat

DESCRIPTION="POSIX Ada Bindings"
HOMEPAGE="http://www.cs.fsu.edu/~baker/florist.html"
SRC_URI="ftp://cs.nyu.edu/pub/gnat/3.15p/florist-3.15p-src.tgz"

DEPEND="<dev-lang/gnat-5.0
	>=sys-apps/sed-4"
RDEPEND=""
LICENSE="GMGPL"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE=""

S="${WORKDIR}/${P}-src"

src_compile() {
	sed -i -e "s:GCST(\"SIGRTMAX\", SIGRTMAX:GCST(\"SIGRTMAX\", (NSIG - 1):" c-posix.c
	econf || die "./configure failed"

	emake \
		GCCFLAGS="${CFLAGS} -fPIC" \
		GNATMAKEFLAGS2B="-cargs -gnatpg ${ADACFLAGS} -fPIC -largs \$(LIBS)" \
		|| die

	# In addition we also generate the shared version of the library
	mkdir ${S}/t
	pushd ${S}/t
	ar xv ../floristlib/libflorist.a
	${ADAC} -shared -o ../floristlib/libflorist-${PV}.so.1 *.o
	cd ..
	rm -rf t
	popd
}

src_install() {
	dodoc README

	insinto /usr/lib/ada/adalib/florist
	doins floristlib/libflorist.a
	doins floristlib/libflorist-${PV}.so.1
	doins floristlib/*.ali

	insinto /usr/lib/ada/adainclude/florist
	doins floristlib/*.ads
	doins floristlib/*.adb

	cd ${D}/usr/lib/ada/adalib/florist
	ln -s libflorist-${PV}.so.1 libflorist.so
	cd ${S}

	#set up environment
	dodir /etc/env.d
	echo "ADA_OBJECTS_PATH=/usr/lib/ada/adalib/${PN}" \
		> ${D}/etc/env.d/55florist
	echo "ADA_INCLUDE_PATH=/usr/lib/ada/adainclude/${PN}" \
		>> ${D}/etc/env.d/55florist
}

pkg_postinst() {
	einfo "The envaironment has been set up to make gnat automatically find files for"
	einfo "Florist. In order to immediately activate these settings please do:"
	einfo "env-update"
	einfo "source /etc/profile"
	einfo "Otherwise the settings will become active next time you login"
}

