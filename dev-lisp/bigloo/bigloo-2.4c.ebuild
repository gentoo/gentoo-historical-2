# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/bigloo/bigloo-2.4c.ebuild,v 1.2 2002/07/11 06:30:21 drobbins Exp $

S=${WORKDIR}/${PN}${PV}
DESCRIPTION="Bigloo Scheme compiler for x86, sparc, alpha, ppc and JVM"
SRC_URI="ftp://ftp-sop.inria.fr/mimosa/fp/Bigloo/bigloo${PV}.tar.gz"
HOMEPAGE="http://www-sop.inria.fr/mimosa/fp/Bigloo/bigloo.html"

DEPEND=""
#RDEPEND=""

src_compile() {
	local myconf
	local myjava=`java-config --java`
	local myjavac=`java-config --javac`

	use java && 
		myconf="--jvm=force --java=$myjava --javac=$myjavac" \
		|| myconf="--jvm=no"


	./configure \
		--native=yes \
		--cflags="${CFLAGS}" \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man/man1 \
		--docdir=/usr/share/doc/${PV} \
		$myconf || die "./configure failed"

	cp Makefile.config Makefile.config.orig
	sed "s/JCFLAGS=-O/JCFLAGS=/" \
		< Makefile.config.orig \
		> Makefile.config
	echo LD_LIBRARY_PATH=${S}/lib/2.4c >> Makefile.config
	
	cp bde/Makefile bde/Makefile.orig
	sed "s/\$(BOOTBINDIR)\/afile jas/LD_LIBRARY_PATH=\$(LD_LIBRARY_PATH) \$(BOOTBINDIR)\/afile jas/" \
		< bde/Makefile.orig \
		> bde/Makefile

	cp Makefile.config Makefile.config.fixed

	make || die
}

src_install () {
	dodir /usr/bin
	dodir /usr/lib
	dodir /usr/share/doc/${PV}
	dodir /usr/share/man/man1
	dodir /usr/share/info

	sed \
		-e "s:^BINDIR=\(.*\):BINDIR=${D}\1:" \
		-e "s:^LIBDIR=\(.*\):LIBDIR=${D}\1:" \
		-e "s:^MANDIR=\(.*\):MANDIR=${D}\1:" \
		-e "s:^INFODIR=\(.*\):INFODIR=${D}\1:" \
		-e "s:^DOCDIR=\(.*\):DOCDIR=${D}\1:" \
		< Makefile.config.fixed \
		> Makefile.config
	
	dodir /etc/env.d
	echo "LDPATH=/usr/lib/bigloo/${PV}/" \
		> ${D}/etc/env.d/25bigloo
	make install || die
}
