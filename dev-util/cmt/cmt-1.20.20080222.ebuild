# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cmt/cmt-1.20.20080222.ebuild,v 1.2 2008/10/13 22:09:40 bicatali Exp $

inherit elisp-common toolchain-funcs versionator

CPV=($(get_version_components ${PV}))
CMT_PV=v${CPV[0]}r${CPV[1]}p${CPV[2]}

DESCRIPTION="Cross platform configuration management environment"
HOMEPAGE="http://www.cmtsite.org/"
SRC_URI="http://www.cmtsite.org/${CMT_PV}/CMT${CMT_PV}.tar.gz"

LICENSE="CeCILL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="emacs java doc"

DEPEND="emacs? ( virtual/emacs )"
RDEPEND="${DEPEND}
	java? ( virtual/jdk )"

S="${WORKDIR}/CMT/${CMT_PV}"

src_compile() {
	cd "${S}"/mgr
	./INSTALL
	source setup.sh
	emake -j1 \
		cpp="$(tc-getCXX)" \
		cppflags="${CXXFLAGS}" \
		|| die "make failed"

	sed -i -e "s:${WORKDIR}:/usr/$(get_libdir):g" setup.*sh
	cd "${S}"
	mv src/demo .
	rm -f ${CMTBIN}/*.o

	if use emacs; then
		elisp-compile doc/cmt-mode.el || die
	fi
}

src_install() {
	CMTDIR=/usr/$(get_libdir)/CMT/${CMT_PV}
	dodir ${CMTDIR}
	cp -pPR mgr src ${CMTBIN} "${D}"/${CMTDIR}
	dodir /usr/bin
	dosym ${CMTDIR}/${CMTBIN}/cmt.exe /usr/bin/cmt

	cat > 99cmt <<-EOF
		 CMTROOT="${CMTDIR}"
		 CMTBIN="$(uname)-$(uname -m | sed -e 's# ##g')"
		 CMTCONFIG="$(${CMTROOT}/mgr/cmt_system.sh)"
	EOF
	if use java; then
		cp -pPR java "${D}"/${CMTDIR}
		echo "#!/bin/sh" > jcmt
		echo "java cmt_parser" >> jcmt
		exeinto /usr/bin
		doexe jcmt || die "doexe failed"
		echo "CLASSPATH=\"${CMTDIR}/java/cmt.jar\"" >> 99cmt
	fi

	doenvd 99cmt || die "doenvd failed"
	dodoc ChangeLog doc/*.txt || die "dodoc failed"
	dohtml doc/{ChangeLog,ReleaseNotes}.html || die "dohtml failed"

	if use doc; then
		cd "${S}"/mgr
		emake gendoc || die "emake gendoc failed"
		insinto /usr/share/doc/${PF}
		cd "${S}"/doc
		doins -r {CMTDoc,CMTFAQ}.{html,pdf} Images || die "doc install failed"
		cd "${S}"
		doins -r demo || die "doins demo failed"
	fi

	if use emacs; then
		elisp-install ${PN} doc/cmt-mode.{el,elc} || die
		elisp-site-file-install "${FILESDIR}"/80cmt-mode-gentoo.el || die
	fi
}

pkg_postinst () {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
