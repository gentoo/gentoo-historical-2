# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/cm/cm-2.10.0.ebuild,v 1.11 2007/04/07 16:36:05 josejx Exp $

inherit elisp-common

DESCRIPTION="Common Music: An object oriented music composition environment in LISP/scheme"
HOMEPAGE="http://commonmusic.sourceforge.net"
SRC_URI="mirror://sourceforge/commonmusic/${P}.tar.gz"

LICENSE="LLGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"

COMPILERS="dev-lisp/openmcl
	>=dev-lisp/sbcl-1.0.1
	dev-lisp/cmucl
	dev-lisp/clisp"

INTERPRETERS="dev-lisp/ecls
	dev-scheme/guile
	dev-scheme/gauche"

DEPEND="|| ( ${COMPILERS} ${INTERPRETERS} )
		emacs? ( virtual/emacs app-emacs/slime )
		test? ( app-shells/tcsh )"
RDEPEND="${DEPEND}"

IUSE="doc emacs test"

S="${WORKDIR}/${PN}"

SITEFILE="71cm-gentoo.el"

# for easy testing of any implementation
#FORCEIMPL="guile"
#FORCEIMPL="sbcl"

CM="${S}/bin/cm.sh -R . -l \"\${FORCEIMPL}\""
#echo "${CM}"

implementation() {
	if [[ ! -z "${FORCEIMPL}" ]]; then
		echo "${FORCEIMPL}"
		return
	fi
	local impl=$(bin/cm.sh -nv | grep Executable)
	impl=${impl##*bin/}
	echo ${impl}
}

is_lisp() {
	local impl="$(implementation)"
#	echo ${impl}
	if [[ ${impl} == "guile" || ${impl} == "gauche" ]]; then
		return $(false)
	fi
	return $(true)
}

is_compiler() {
	local impl="$(implementation)"
#	echo ${impl}
	if [[ -z $(echo ${COMPILERS} | grep -i ${impl}) ]]; then
		return $(false)
	fi
	return $(true)
}

src_compile() {
	use emacs && elisp-comp etc/xemacs/*.el

	einfo "Detected $(is_compiler && echo "compiler" || echo "interpreter"): $(implementation)"

	if is_compiler; then
		einfo "Byte-compiling code"
		echo '(quit)' | eval ${CM}
	fi
}

src_test() {
#	echo   "(if '()\
#		(begin (display \"scheme\") (load \"etc/test.cm\") (test-cm))\
#		(progn (format t \"commonlisp\") (load \"etc/test.cm\") (test-cm)))"\
#		| eval ${CM}

	echo '(load "etc/test.cm")(test-cm)' | eval ${CM}
}

src_install() {
	insinto /usr/share/${PN}/
	for dir in "bin etc src"; do
		doins -r ${dir}
	done;
	doins cm.asd
	chmod +x ${D}/usr/share/${PN}/bin/cm.sh
	dosym /usr/share/${PN}/bin/cm.sh /usr/bin/${PN}

	mv doc/changelog.text .
	dodoc readme.text changelog.text

	use doc && dohtml -r doc/*

	if use emacs; then
		elisp-install ${PN} etc/xemacs/*.el
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	# make compiled lisp code newer than source files to prevent recompilation
	sleep 1 && find ${ROOT}/usr/share/${PN}/bin/ -iname *fasl -exec touch '{}' \;
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
