# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2.
# Maintainer: Chris Houser <chouser@gentoo.org>
# Author: Defresne Sylvain (keiichi) <kamisama@free.fr>,  Chris Houser <chouser@gentoo.org>
 

P="${P//_/}"
S="${WORKDIR}/${P}/src/=build"
DESCRIPTION="revision control system ideal for widely distributed development"
SRC_URI="ftp://regexps.com/pub/src/arch/${P}.tar.gz"
HOMEPAGE="http://www.regexps.com/#arch"
SLOT="0"

DEPEND="sys-apps/diffutils
	sys-apps/fileutils
	sys-apps/findutils
	sys-apps/gawk
	sys-apps/sh-utils
	sys-apps/tar
	sys-apps/textutils
	sys-apps/util-linux
	sys-apps/debianutils
	sys-devel/make
	sys-devel/patch"

src_unpack() {
	local t

	unpack "${A}"
	mkdir -p "${P}/src/=build"

	# patch arch to install its scripts in /usr/share/arch
	# instead of /usr/libexec/arch (there is only shareables scripts).
	t="${P}/src/build-tools/Makefiles/rules.mk"

	cp ${t} ${t}.orig
	sed 's:/libexec:/share:g' ${t}.orig > ${t} || die "Patch failed for $t"
}

src_compile() {
	# configure
	../configure --prefix="/usr" \
		--with-posix-shell="/bin/bash" \
		--with-sendmail="/usr/sbin/sendmail" || die "configure failed"

	# build
	emake || die "emake failed"
}

src_install () {
	local name

	# install
	make install prefix="${D}/usr" \
		|| die "make install failed"

	# make symlinks relative instead of absolute
	for name in ${D}/usr/share/arch/arch/*; do
		name="`readlink ${name} | sed 's:^.*/usr/share/arch/::'`"
		if [ "${name}" ]; then
			ln -sf "../${name}" "${D}/usr/share/arch/arch/${name#*/}"
			assert "Fixing symlink for ${name} failed"
		fi
	done

	# get some docs
	cd ${WORKDIR}/${P}
	dodoc =NEWS =README COPYING
	dohtml docs/html/*
}

pkg_postinst() {
	echo "Tom Lord's 'arch' command has been renamed upstream to 'larch'"
	echo "to stop collision with 'arch' command."
}
