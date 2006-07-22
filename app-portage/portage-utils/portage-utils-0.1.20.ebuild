# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/portage-utils/portage-utils-0.1.20.ebuild,v 1.1 2006/07/22 23:05:30 solar Exp $

inherit toolchain-funcs

DESCRIPTION="small and fast portage helper tools written in C"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="python"

DEPEND=""

src_compile() {
	use python && export PYTHON=1
	unset PYTHON
	emake || die
}

src_install() {
	dobin q || die "dobin failed"
	doman man/*.[0-9]
	for applet in $(<applet-list) ; do
		dosym q /usr/bin/${applet}
	done
}

pkg_postinst() {
	[ -e ${ROOT}/etc/portage/bin/post_sync ] && return 0
	mkdir -p ${ROOT}/etc/portage/bin/

cat <<__EOF__ > ${ROOT}/etc/portage/bin/post_sync
#!/bin/sh
# Copyright 2006-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

if [ -d /etc/portage/postsync.d/ ]; then
	for f in /etc/portage/postsync.d/* ; do
		if [ -x \${f} ] ; then
			\${f}
		fi
	done
else
	:
fi
__EOF__
	chmod 755 ${ROOT}/etc/portage/bin/post_sync
	if [ ! -e ${ROOT}/etc/portage/postsync.d/q-reinitialize ]; then
		mkdir -p ${ROOT}/etc/portage/postsync.d/
		echo -e '[ -x /usr/bin/q ] && /usr/bin/q -r' > ${ROOT}/etc/portage/postsync.d/q-reinitialize
		chmod 755 ${ROOT}/etc/portage/postsync.d/q-reinitialize
	fi
	:
}
