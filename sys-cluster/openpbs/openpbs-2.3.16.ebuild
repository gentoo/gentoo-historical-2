# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/openpbs/openpbs-2.3.16.ebuild,v 1.12 2004/08/08 00:39:46 slarti Exp $

NAME=`echo ${P} | sed -e "s|openpbs-|OpenPBS_|; y|.|_|"`
B=${NAME}.tar.gz
S="${WORKDIR}/${NAME}.tar.gz"

DESCRIPTION="The Portable Batch System (PBS) is a flexible batch queuing and workload management system"
HOMEPAGE="http://www.openpbs.org/"
LICENSE="openpbs"

SLOT="0"
KEYWORDS="x86"
IUSE="X tcltk"

DEPEND="virtual/libc
		X? ( virtual/x11 )
		tcltk? ( dev-lang/tcl )"
RDEPEND="net-misc/openssh"


src_unpack() {
	if [ ! -e ${DISTDIR}/${A} ] ; then
		einfo "Due to license issues you have to download"
		einfo "the appropriate openpbs archive:"
		einfo "http://www.openpbs.org/UserArea/Download/"${B}
		einfo ""
		einfo "The archive should be placed into ${DISTDIR}."

		die "package archive not found"
	fi

	cd ${WORKDIR}
	unpack ${B}
	cd ${S}
	# apply a patch I made for gcc3. 
	# maybe this should be done with sed but I'm too lazy
	patch -p0 < ${FILESDIR}/makedepend-sh-gcc3.patch

	# this thing doesn't use make install, but rather it's own install script
	# fix it here so the install dirs are set to the ${D} directory
	cd buildutils
	mv pbs_mkdirs.in pbs_mkdirs.in-orig
	sed -e "s|prefix=@prefix@|prefix=\${D}@prefix@| ; \
			s|PBS_SERVER_HOME=@PBS_SERVER_HOME@|PBS_SERVER_HOME=\${D}@PBS_SERVER_HOME@| ; \
			s|PBS_DEFAULT_FILE=@PBS_DEFAULT_FILE@|PBS_DEFAULT_FILE=\${D}@PBS_DEFAULT_FILE@| ; \
			s|PBS_ENVIRON=@PBS_ENVIRON@|PBS_ENVIRON=\${D}@PBS_ENVIRON@|" \
			pbs_mkdirs.in-orig > pbs_mkdirs.in
}

src_compile() {
	local myconf
	use X || myconf="--disable-gui"
	use tcltk && myconf="${myconf} --with-tcl"

	./configure ${myconf} \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--enable-docs \
		--enable-server \
		--enable-mom \
		--enable-clients \
		--set-server-home=/var/spool/PBS \
		--set-environ=/etc/pbs_environment \
		--with-scp || die "./configure failed"

	make || die
}

src_install() {

	make prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		PBS_SERVER_HOME=${D}/var/spool/PBS \
		install || die

	dodoc INSTALL PBS_License.text Read.Me Release_Notes
}
